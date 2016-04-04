#!/bin/sh

printf "Monitoring /vagrant for .ovpn files"

while :; do
    cfg="$(printf '%s\n' /vagrant/*.ovpn | shuf | head -n1)"

    if [ -f "$cfg" ]; then
        printf "\n"
        printf "%s\n" "Found file '$cfg'. Starting openvpn:"

        sudo openvpn \
            --script-security 2 \
            --up /etc/openvpn/update-resolv-conf \
            --config "$cfg"
    fi

    sleep 5
    printf "."
done
