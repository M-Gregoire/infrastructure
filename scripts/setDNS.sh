
if [ -z "$1" ]; then
	echo "Interface not specified"
	exit 1
fi


if [ -z "$2" ]; then
        echo "DNS not specified"
        exit 1
fi

SETTINGS=""
if [ ! -z "$3" ]; then
        echo "Adding domain $3"
	SETTINGS+=" --set-domain $3"
fi


INTERFACE=$(networkctl list | grep "$1" | tr -s ' ' | xargs)
INTERFACE_NB=$(echo $INTERFACE | cut -d ' ' -f 1)
INTERFACE_NAME=$(echo $INTERFACE | cut -d ' ' -f 2)
if [ -z "$INTERFACE_NB" ]; then
        echo "Unable to get interface number. Is is correct interface name?"
        exit 1
else
	echo "Interface number: $INTERFACE_NB"
fi
if [ -z "$INTERFACE_NAME" ]; then
        echo "Unable to get interface name. Is is correct interface name?"
        exit 1
else
        echo "Interface name: $INTERFACE_NAME"
fi

sudo systemd-resolve --interface $INTERFACE_NAME --set-dns $2 $SETTINGS
sudo networkctl down $INTERFACE_NAME
sudo networkctl up $INTERFACE_NAME

#busctl call org.freedesktop.resolve1 /org/freedesktop/resolve1 org.freedesktop.resolve1.Manager SetLinkDNS 'ia(iay)' $INTERFACE_NB 1 2 4 8 8 8 8
