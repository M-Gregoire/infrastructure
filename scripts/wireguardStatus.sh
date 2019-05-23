#!/usr/bin/env bash
STATUS=$(systemctl status wireguard-wg0.service)
REACHED=$(echo $STATUS | grep "Network is unreachable")

if systemctl is-active --quiet wireguard-wg0.service;
then
    if [ -z "$REACHED" ]
    then
	printf '\uf023'
    else
	printf '\ue009'
    fi
else
    printf '\uf09c'
fi
