#!/bin/bash


echo "Obtaining cipher list from $(openssl version)."
echo
OPENSSL_CIPHERS=$(openssl ciphers 'ALL:eNULL' | tr ':' ' ')
OPENSSL_PFS_CIPHERS=$(openssl ciphers 'ALL:eNULL' | tr ':' '\n' | grep 'DH' | tr '\n' ' ')

DELAY=0
SSL_IMPLEMENTATION="openssl"
CIPHERS="${OPENSSL_CIPHERS[@]}"
CSV_FILE="cipher_test.csv"
SUBJECTS_FILE="subjects.cfg"

test -f ciphercompare.cfg && source ciphercompare.cfg

function ssl_scan { # {{{
    # prepared for more implementations
    case $SSL_IMPLEMENTATION in
        openssl)
            openssl_scan $@
        ;;
        *)
            echo "not implemented"
        ;;
    esac
} # }}}

function openssl_scan { # {{{

    cipher=$1
    server=$2
    port=$3
    if [ "x${4}" != "x" ]; then
        local_starttls="-starttls ${4}"
    else
        local_starttls=""
    fi

    devnull=$(echo -n | openssl s_client -cipher "${cipher}" -connect ${server}:${port} ${local_starttls} 2>&1)

    return $? 

} # }}}

function scan_server { # {{{
    
    server=$1
    port=$2
    starttls=$3

    cipher_results=""
   
    for cipher in ${CIPHERS[@]}; do

        echo -ne "Checking ${server}:${port} for ${cipher} ... " >&2

        if ssl_scan "${cipher}" "${server}" "${port}" "${starttls}"; then
            echo "yes" >&2
            cipher_results="${cipher_results}yes;"
        else
            echo "no" >&2
            cipher_results="${cipher_results}no;"
        fi

        sleep ${DELAY}
    done
    echo "${cipher_results}"
} # }}}

cipher_header="${CIPHERS[@]}"
echo "Provider;Service;Hostname;Port;${cipher_header//\ /;};" > ${CSV_FILE}

cat ${SUBJECTS_FILE} | while read line; do

    e=( ${line[@]} )

    case ${e[0]} in
        =)
            provider="${e[1]}"
        ;;
        +)

            service="${e[1]}"
            hostname="${e[2]}"
            port="${e[3]}"
            ssl_type="${e[4]}"
            starttls_protocol="${e[5]}"
            
            # Here we do the scan

            result="$(scan_server ${hostname} ${port} ${starttls_protocol})"
            echo "${provider};${service};${hostname};${port};${result}" >> ${CSV_FILE}

        ;;
        *)
        ;;
    esac


done

# vim:fdm=marker:ts=4:sw=4:sts=4:ai:sta:et
