#!/usr/bin/with-contenv bashio
declare password
declare port
declare username


# Require a secure password
bashio::config.require.safe_password 'logins.password'

# Get the port
port=$(bashio::addon.port 631)
sed -i "s/Listen localhost:631/Port ${port}/" /etc/cups/cupsd.conf

# Make sure the username is lowercase
username=$(bashio::config 'logins.username')
username=$(bashio::string.lower "${username}")
password=$(bashio::config 'logins.password')

if [ "$(grep -ci "${username}" /etc/shadow)" -eq 0 ]; then
  adduser -S -G lpadmin --no-create-home "${username}"
  chpasswd <<< "${username}:${password}" 2&> /dev/null
fi

# sed -i "s/@SYSTEM/${username}/" /etc/cups/cupsd.conf

exec /usr/sbin/cupsd -f