#!/bin/sh
# 2015 Alexander Couzens <lynxis@fe80.eu>
# under MIT license

# ideally, we'd like to use the following line:
#   set -eu
# however, jshn.sh does not initialize all variables

. /usr/share/libubox/jshn.sh

log() {
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
  local known_keys="name passwordHash"

	json_select router

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			passwordHash)
			  sed -i -e "s/^root:[^:]*:/root:$val:/" /etc/shadow
				;;
			name)
				uci set "system.@system[0].hostname=$val"
				;;
		esac
	done

	uci commit system

	json_select ..
}

contact_handler() {
	local key
	local val
  local known_keys="name email"

	json_select contact

	touch /etc/config/freifunk
	uci set freifunk.contact=public

	for key in $known_keys ; do
		json_get_var val "$key"

		case "$key" in
			name|email)
				uci set "freifunk.contact.$key=$val"
				;;
			*)
				log info "Dont know to do with contact.$key"
				;;
		esac
	done

	uci commit freifunk

	json_select ..
}

location_handler() {
	local key
	local val

	json_select location

	json_get_vars lat lon street postalCode city

	uci set "system.@system[0].latitude=$lat"
	uci set "system.@system[0].longitude=$lon"
	uci set "system.@system[0].latlon=$lat $lon"
	uci set "system.@system[0].location=$street, $postalCode, $city"
	uci commit system

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
				log info "Dont know to do with internet.$key"
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
				log info "Dont know to do with ip.$key"
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
				log info "Dont know to do with wifi.$key"
				;;
		esac
	done

	json_select ..
}

parser() {
	local config=$(cat $1)

	json_init
	json_load "$config"

	check_json_contains "router" && router_handler
	check_json_contains "contact" && contact_handler
	check_json_contains "location" && location_handler
	#check_json_contains "internet" && internet_handler
	#check_json_contains "ip" && ip_handler
	#check_json_contains "wifi" && wifi_handler
}

parser "$1"
