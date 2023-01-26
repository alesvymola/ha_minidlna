#!/usr/bin/with-contenv bashio
bashio::log.info "Start"

CONFIG_PATH=/data/options.json
SYSTEM_USER=/data/system_user.json

declare ingress_interface
declare ingress_port
declare ingress_entry

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
ingress_entry=$(bashio::addon.ingress_entry)

MEDIA_DIR="$(bashio::config 'media_dir')"
FRIENDLY_NAME="$(bashio::config 'friendly_name')"
DB_DIR="$(bashio::config 'db_dir')"
dirlist=$(echo $MEDIA_DIR | tr ";" "\n")

for dir in $dirlist
do
    echo "> setting media dir: [media_dir=$dir]"
	sed -i "/XXXmedia_dirXXX/a \media_dir=$dir" /etc/minidlna.conf
done

echo "> setting friendly name: [friendly_name=$FRIENDLY_NAME]"
sed -i "s/%%friendly_name%%/${FRIENDLY_NAME}}/g" /etc/minidlna.conf

echo "> setting db dir: [db_dir=$DB_DIR]"
sed -i "s/%%db_dir%%/${DB_DIR}}/g" /etc/minidlna.conf

#MEDIA_DIR2="$(bashio::config 'media_dir2')"
#sed -i "s%XXXmedia_dir2XXX%$MEDIA_DIR2%g" /etc/minidlna.conf

echo "> setting ingress port: [port=$ingress_port]"
sed -i "s/%%port%%/${ingress_port}/g" /etc/minidlna.conf

OPTIONS="$(bashio::config 'options')"
bashio::log.info "Starting MiniDLNA..."
usr/sbin/minidlnad $OPTIONS
