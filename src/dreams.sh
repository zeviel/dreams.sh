#!/bin/bash

api="https://dreams-api.evgrg.tech"
sign=null
vk_user_id=null
vk_ts=null
vk_ref=null
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36"

function authenticate() {
	# 1 - sign: (string): <sign>
	# 2 - vk_user_id: (integer): <vk_user_id>
	# 3 - vk_ts: (integer): <vk_ts>
	# 4 - vk_ref: (string): <vk_ref>
	# 5 - access_token_settings: (string): <access_token_settings - default: >
	# 6 - are_notifications_enabled: (integer): <are_notifications_enabled: default: 0>
	# 7 - is_app_user: (integer): <is_app_user - default: 0>
	# 8 - is_favorite: (integer): <is_favorite - default: 0>
	# 9 - language: (string): <language - default: ru>
	# 10 - platform: (string): <platform - default: desktop_web>
	sign=$1
	vk_user_id=$2
	vk_ts=$3
	vk_ref=$4
	params="vk_access_token_settings=${5:-}&vk_app_id=51456689&vk_are_notifications_enabled=${6:-0}&vk_is_app_user=${7:-0}&vk_is_favorite=${8:-0}&vk_language=${9:-ru}&vk_platform=${10:-desktop_web}&vk_ref=$vk_ref&vk_ts=$vk_ts&vk_user_id=$vk_user_id&sign=$sign"
}

function get_profile() {
	curl --request GET \
		--url "$api/profile" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params"
}

function get_dreams() {
	# 1 - type: (string): <type - default: new>
	# 2 - offset: (integer): <offset - default: 0>
	curl --request GET \
		--url "$api/getList?type=${1:-new}&offset=${2:-0}" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params"
}

function like_dream() {
	# 1 - type: (string): <type>
	# 2 - dream_id: (integer): <dream_id>
	curl --request POST \
		--url "$api/like?type=$1" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params" \
		--data '{
			"id": "'$2'"
		}'
}


function report_dream() {
	# 1 - dream_id: (integer): <dream_id>
	# 2 - text: (string): <text - default: "">
	curl --request POST \
		--url "$api/report" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params" \
		--data '{
			"id": "'$1'",
			"text": "'${2:-""}'"
		}'
}

function create_dream() {
	# 1 - text: (string): <text>
	# 2 - is_anon: (boolean): <true, false - default: false>
	curl --request POST \
		--url "$api/create" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params" \
		--data '{
			"text": "'$1'",
			"isAnon": "'${2:-false}'"
		}'
}

function delete_dream() {
	# 1 - dream_id: (integer): <dream_id>
	curl --request POST \
		--url "$api/delete" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "xvk: $params" \
		--data '{
			"id": "'$1'"
		}'
}
