#!/usr/bin/env bash

# Interactive `brew update` + `brew upgrade` that repairs AeroSpace's TCC grants
# when the upgrade replaces the app.
#
# AeroSpace ships signed with a self-signed certificate whose leaf hash changes
# between releases. macOS stores the app's designated requirement inside every
# TCC record, so an upgrade silently invalidates Screen Recording while System
# Settings still shows the toggle as on -- screenshots then come back as the
# desktop picture with no windows.
#
# The designated requirement is what gets compared, not the version string,
# because that is what macOS actually matches against. It is cached between runs
# so drift is still caught when the upgrade happened outside this script.
#
# Run with --check to compare and repair without touching brew.

app='/Applications/AeroSpace.app'
bundle_id='bobko.aerospace'
tap='nikitabobko/tap'
state="${XDG_CACHE_HOME:-$HOME/.cache}/aerospace-designated-requirement"

# The binding that runs screencapture, used only for the optional test at the
# end. Keep it in sync with ~/.aerospace.toml.
screenshot_binding='cmd-s'

red='\033[0;31m' green='\033[0;32m' yellow='\033[0;33m' blue='\033[0;34m' off='\033[0m'

say()  { printf '%b==>%b %s\n' "$blue" "$off" "$*"; }
ok()   { printf '%b==>%b %s\n' "$green" "$off" "$*"; }
warn() { printf '%b==>%b %s\n' "$yellow" "$off" "$*"; }
err()  { printf '%b==>%b %s\n' "$red" "$off" "$*" >&2; }

# ask <prompt> <y|n>, where the second argument is the default on a bare return.
ask() {
	local reply default=$2 hint
	[ "$default" = y ] && hint='[Y/n]' || hint='[y/N]'
	read -r -p "$(printf '%b?%b %s %s ' "$yellow" "$off" "$1" "$hint")" reply
	[ -z "$reply" ] && reply=$default
	case $reply in [yY]*) return 0 ;; *) return 1 ;; esac
}

designated_requirement() {
	[ -d "$app" ] || return 1
	codesign -d -r- "$app" 2>/dev/null | sed -n 's/^designated => //p'
}

installed_version() {
	plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist" 2>/dev/null
}

reset_service() {
	local service=$1
	if tccutil reset "$service" "$bundle_id" >/dev/null 2>&1; then
		ok "reset $service"
	else
		err "tccutil reset $service failed -- remove AeroSpace from the list in System Settings with the - button instead"
	fi
}

restart_aerospace() {
	local waited=0
	osascript -e 'quit app "AeroSpace"' >/dev/null 2>&1
	while pgrep -qx AeroSpace && [ "$waited" -lt 20 ]; do
		sleep 0.25
		waited=$((waited + 1))
	done
	open -a "$app" || return 1
	sleep 2
	pgrep -qx AeroSpace
}

# tccd logs this line every time it rejects a stored grant whose pinned
# signature no longer matches the installed app.
requirement_mismatch_logged() {
	log show --last "$1" --style compact --predicate 'process == "tccd"' 2>/dev/null |
		grep -qF "Failed to match existing code requirement for subject $bundle_id"
}

usage() {
	cat <<'USAGE'
usage: brew-upgrade.sh [--check]

  (no args)  brew update, brew upgrade, then repair AeroSpace TCC grants if its
             code signature changed
  --check    only compare AeroSpace's signature against the cached one and offer
             to repair
USAGE
}

check_only=false
case ${1:-} in
	--check) check_only=true ;;
	-h | --help)
		usage
		exit 0
		;;
	'') ;;
	*)
		usage
		exit 2
		;;
esac

if [ ! -d "$app" ]; then
	err "no AeroSpace at $app"
	exit 1
fi

mkdir -p "$(dirname "$state")"

if $check_only; then
	before_dr=$(cat "$state" 2>/dev/null)
	if [ -z "$before_dr" ]; then
		warn "no cached signature yet -- recording the current one as the baseline"
		designated_requirement >"$state"
		ok "baseline saved to $state"
		exit 0
	fi
else
	before_dr=$(designated_requirement)
	before_ver=$(installed_version)

	say 'brew update'
	# A tap whose upstream repo is gone fails the whole update. Homebrew names the
	# tap to remove in that error, so offer to act on it and retry once.
	update_log=$(mktemp)
	trap 'rm -f "$update_log"' EXIT
	brew update 2>&1 | tee "$update_log"
	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
		dead_taps=$(sed -n 's/.*Run `brew untap \([^`]*\)`.*/\1/p' "$update_log" | sort -u)
		if [ -z "$dead_taps" ]; then
			err 'brew update failed'
			exit 1
		fi
		ask "untap $(echo $dead_taps | tr '\n' ' ')and retry?" y || {
			err 'brew update failed'
			exit 1
		}
		# shellcheck disable=SC2086
		brew untap $dead_taps || err 'brew untap failed'
		brew update || {
			err 'brew update still failing'
			exit 1
		}
	fi
	rm -f "$update_log"
	trap - EXIT

	# Newer Homebrew refuses to load casks from untrusted third-party taps, which
	# makes the AeroSpace upgrade a silent no-op rather than an error.
	if ! brew list --cask --versions aerospace >/dev/null 2>&1 && brew tap | grep -qx "$tap"; then
		warn "$tap is untrusted, so brew upgrade will skip AeroSpace"
		if ask "run 'brew trust $tap'?" y; then
			brew trust "$tap" || err 'brew trust failed'
		fi
	fi

	say 'outdated'
	brew outdated

	ask 'run brew upgrade?' y || exit 0
	brew upgrade || warn 'brew upgrade reported errors -- continuing to the AeroSpace check'
fi

after_dr=$(designated_requirement)
after_ver=$(installed_version)

if [ "$before_dr" = "$after_dr" ]; then
	ok "AeroSpace signature unchanged (${after_ver:-unknown}) -- TCC grants intact"
	printf '%s\n' "$after_dr" >"$state"
	exit 0
fi

echo
warn "AeroSpace signature changed -- its TCC grants are now stale"
[ -n "${before_ver:-}" ] && printf '    version  %s -> %s\n' "$before_ver" "${after_ver:-unknown}"
printf '    was      %s\n' "${before_dr:-<none>}"
printf '    now      %s\n' "$after_dr"
echo

if ask 'reset Screen Recording so it can be re-granted?' y; then
	reset_service ScreenCapture
fi

# A changed requirement invalidates every service, not just Screen Recording.
# Accessibility is left opt-in because resetting it stops window management until
# it is re-granted.
warn 'Accessibility and Automation grants are stale for the same reason'
if ask 'also reset Accessibility? (window management stops until re-granted)' n; then
	reset_service Accessibility
fi
if ask 'also reset Automation (AppleEvents)?' n; then
	reset_service AppleEvents
fi

echo
if ask 'restart AeroSpace now?' y; then
	if restart_aerospace; then
		ok 'AeroSpace restarted'
	else
		err 'AeroSpace did not come back -- start it manually before continuing'
	fi
fi

printf '%s\n' "$after_dr" >"$state"

cat <<'NEXT'

Next, grant the permission:
  1. Trigger a screenshot. Screen Recording cannot show an inline prompt, so
     macOS posts a notification instead.
  2. Click through to System Settings > Privacy & Security > Screen & System
     Audio Recording and enable AeroSpace. If no notification appears, add
     /Applications/AeroSpace.app there by hand.
NEXT

if ask "trigger the ${screenshot_binding} binding now to test?" y; then
	if aerospace trigger-binding "$screenshot_binding" --mode main 2>/dev/null; then
		read -r -p "$(printf '%b?%b press return once the selection is done ' "$yellow" "$off")" _
		if requirement_mismatch_logged 1m; then
			err 'tccd is still rejecting the grant -- re-run and reset again, or remove the entry in System Settings with the - button'
		else
			ok 'no requirement mismatch logged -- the grant took'
		fi
	else
		err "could not trigger ${screenshot_binding} -- press it by hand"
	fi
fi
