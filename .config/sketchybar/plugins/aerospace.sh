#!/usr/bin/env bash

source "${CONFIG_DIR}/colors.sh"

function get_workspace_running_apps() {
	local workspace=${1}
	local apps=$(aerospace list-windows --workspace ${workspace} | awk -F '\\| *' '{print $2}')

	printf "%s" "${apps}"
}

function update_on_workspace_change() {
	local workspace=${1}
	local action=${2}
	local apps
	apps=$(get_workspace_running_apps "${workspace}")
	space=(
		"click_script=aerospace workspace ${workspace}"
		"script=${CONFIG_DIR}/plugins/aerospace.sh ${workspace}"
	)

	if [[ -n "${apps}" ]]; then
		space+=("icon.drawing=on" "label.drawing=on"
			"icon=${workspace} 󰧞"
		)
	else
		space+=("icon.drawing=on" "label.drawing=on"
			"icon=${workspace}"
		)
	fi
	if [[ "${workspace}" = "${FOCUSED_WORKSPACE}" ]]; then
		space+=(
			"icon.color=${aerospace_active_fg_color}"
			"label.color=${aerospace_active_fg_color}"
			"background.drawing=on"
			"background.color=${aerospace_active_bg_color}"
		)
	else
		space+=(
			"icon.color=${aerospace_inactive_fg_color}"
			"label.color=${aerospace_inactive_fg_color}"
			"background.drawing=off"
		)
	fi

	if [ "$action" = "init" ]; then
		sketchybar --add item space."${workspace}" left \
			--subscribe space."${workspace}" aerospace_workspace_change \
			--set space."${workspace}" "${space[@]}"
	else
		sketchybar --set "${NAME}" "${space[@]}"
	fi

}

case "${SENDER}" in
"aerospace_workspace_change")
	update_on_workspace_change "${1}" ""
	;;
"forced")
	exit
	;;
*)
	update
	;;
esac
