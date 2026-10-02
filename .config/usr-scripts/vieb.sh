#!/usr/bin/env bash
set -euo pipefail

# Usage: vieb.sh [URL...]        open urls as new tabs (starts Vieb detached if needed)
#        vieb.sh --execute CMD   run CMD in the running Vieb and print its output
#        vieb.sh --running       exit 0 when Vieb is running

if ! vieb_bin="$(command -v vieb)"; then
	echo "$0: Vieb not found on PATH" >&2
	exit 1
fi

# Chromium's SingletonLock points at "<host>-<pid>" while an instance owns the datafolder.
vieb_running() {
	local lock
	lock="$(readlink "${VIEB_DATAFOLDER:-$HOME/.config/Vieb}/SingletonLock" 2>/dev/null)" || return 1
	kill -0 "${lock##*-}" 2>/dev/null
}

case "${1:-}" in
--running)
	vieb_running
	;;
--execute)
	vieb_running || exit 1
	# The AppImage needs --no-sandbox on Ubuntu's AppArmor userns restrictions.
	"$vieb_bin" --no-sandbox --execute="$2" 2>/dev/null
	;;
*)
	if vieb_running; then
		"$vieb_bin" --no-sandbox "$@" >/dev/null 2>&1
	else
		setsid -f "$vieb_bin" --no-sandbox "$@" >/dev/null 2>&1
	fi
	;;
esac
