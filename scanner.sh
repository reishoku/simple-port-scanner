#!/usr/bin/env bash

# Tested Environment:
#   macOS Ventura 13.3.1 with bash 5.2.15 (homebrew)

options=$(getopt h:p:t: "$*")

# shellcheck disable=SC2086
set -- $options

while :; do
  case "$1" in
    -h|--host)
      HOST="$2"
      shift; shift
      ;;
    -p|--port)
      PORT="$2"
      shift; shift
      ;;
    -t|--proto)
      if [[ "$2" == "tcp" || "$2" == "udp" ]]; then
        PROTO="$2"
      else
        echo "Invalid protocol; specify tcp or udp"
        break
      fi
      shift; shift
      ;;
    --)
      shift; break
      ;;
     *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

[[ -z "${PROTO}" || -z "${HOST}" || -z "${PORT}" ]] && exit

function port_up(){
  [[ "$#" -eq 3 ]] || ( echo "incorrect argv count" && exit )
  echo "[UP] $*"
}
function port_down(){
  [[ "$#" -eq 3 ]] || ( echo "incorrect argv count" && exit )
  echo "[DOWN] $*"
}

if echo >/dev/"${PROTO}"/"${HOST}"/"${PORT}"; then
  port_up "${HOST}" "${PORT}" "${PROTO}"
else
  port_down "${HOST}" "${PORT}" "${PROTO}"
fi

exit 0
