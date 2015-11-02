#!/bin/sh
# 2015 Alexander Couzens <lynxis@fe80.eu>
# under MIT license

. /usr/share/libubox/jshn.sh

_log() {
	local level=$1
	shift
	logger -s -t freifunk.config -p daemon.$level $@
}

check_json_contains() {
        local look_for="$1"
        local type
        json_get_type type $look_for
        case "$type" in
                object|array|string|int)
                        return 0;
                        ;;
                *)
                        return 1;
                        ;;
        esac
}

router_handler() {
	local key
	local val
        local known_keys="router password"

	json_get_keys keys router
	json_select router

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			password)
				echo -n "$key\n$key\n" | passwd
				;;
			name)
				uci set "system.@system[0].hostname=$val"
				;;
		esac
	done

	json_select ..
}

contact_handler() {
	local key
	local val
        local known_keys="name email"

	json_get_keys keys contact
	json_select contact

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			*)
				log "Dont know to do with contact.$key"
				;;
		esac
	done

	json_select ..
}

location_handler() {
	local key
	local val
        local known_keys="lat lng street postalCode city"

	json_get_keys keys location
	json_select location

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			*)
				log "Dont know to do with location.$key"
				;;
		esac
	done

	json_select ..
}

internet_handler() {
	local key
	local val
        local known_keys="share vpn"

	json_get_keys keys internet
	json_select internet

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			*)
				log "Dont know to do with internet.$key"
				;;
		esac
	done

	json_select ..
}

ip_handler() {
	local key
	local val
        local known_keys="v6Prefix v4MeshIps distribute v4DhcpPrefix"
	json_get_keys keys ip
	json_select ip

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			*)
				log "Dont know to do with ip.$key"
				;;
		esac
	done

	json_select ..
}

wifi_handler() {
	local key
	local val
        local known_keys="channel ap mesh"
	json_get_keys keys wifi
	json_select wifi

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			*)
				log "Dont know to do with wifi.$key"
				;;
		esac
	done

	json_select ..
}

parser() {
	local config=$(cat example.js)

	json init
	json_load "$config"

	check_json_contains "route" && route_handler
	check_json_contains "contact" && contact_handler
	check_json_contains "location" && location_handler
	check_json_contains "internet" && internet_handler
	check_json_contains "ip" && ip_handler
	check_json_contains "wifi" && wifi_handler

}
