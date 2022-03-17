#!/bin/bash
source ./functions.sh

cd "/opt/Dockovpn_data"

LOCKFILE=.gen

# Regenerate certs only on the first start
if [ ! -f $LOCKFILE ]; then

    /usr/share/easy-rsa/easyrsa build-ca nopass << EOF

EOF
    # CA creation complete and you may now import and sign cert requests.
    # Your new CA certificate file for publishing is at:
    # /opt/Dockovpn_data/pki/ca.crt

    /usr/share/easy-rsa/easyrsa gen-req MyReq nopass << EOF2

EOF2
    # Keypair and certificate request completed. Your files are:
    # req: /opt/Dockovpn_data/pki/reqs/MyReq.req
    # key: /opt/Dockovpn_data/pki/private/MyReq.key

    /usr/share/easy-rsa/easyrsa sign-req server MyReq << EOF3
yes
EOF3
    # Certificate created at: /opt/Dockovpn_data/pki/issued/MyReq.crt

    openvpn --genkey --secret ta.key << EOF4
yes
EOF4

    touch $LOCKFILE
fi

# Copy server keys and certificates
cp pki/ca.crt pki/issued/MyReq.crt pki/private/MyReq.key ta.key /etc/openvpn

cd "/opt/Dockovpn"

# Print app version
/opt/Dockovpn/version.sh


CLIENT_PATH="$(createConfig)"
CONTENT_TYPE=application/text
FILE_NAME=client.ovpn
FILE_PATH="$CLIENT_PATH/$FILE_NAME"

echo "$(datef) $FILE_PATH file has been generated"

if (($#))
then

    # Parse string into chars:
    # z    Zip user config
    # p    User password for the zip archive
    FLAGS=$1

    # Switch statement
    case $FLAGS in
        z)
            zipFiles "$CLIENT_PATH"

            CONTENT_TYPE=application/zip
            FILE_NAME=client.zip
            FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            ;;
        zp)
            # (()) engaes arthimetic context
            if (($# < 2))
            then
                echo "$(datef) Not enough arguments" && exit 1
            else
                zipFilesWithPassword "$CLIENT_PATH" "$2"

                CONTENT_TYPE=application/zip
                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            fi
            ;;
        o)
                cat "$FILE_PATH"
                exit 0
            ;;
        oz)
            zipFiles "$CLIENT_PATH" -q

            FILE_NAME=client.zip
            FILE_PATH="$CLIENT_PATH/$FILE_NAME"
            cat "$FILE_PATH"
            exit 0
            ;;
        ozp)
            if (($# < 2))
            then
                echo "$(datef) Not enough arguments" && exit 1
            else
                zipFilesWithPassword "$CLIENT_PATH" "$2" -q

                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                cat "$FILE_PATH"
                exit 0
            fi
            ;;
        *) echo "$(datef) Unknown parameters $FLAGS"
            ;;

    esac
fi

echo "$(datef) Config server started, download your $FILE_NAME config at http://$HOST_ADDR/"
echo "$(datef) NOTE: After you download your client config, http server will be shut down!"

#{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat "$FILE_PATH"; } | nc -w0 -l 8080

echo "$(datef) Config http server has been shut down"