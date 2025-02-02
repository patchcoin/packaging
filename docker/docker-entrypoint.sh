#!/bin/bash
set -e

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for patchcoind"
  set -- patchcoind "$@"
fi

if [ "$(echo "$1" | cut -c1)" = "-" ] || [ "$1" = "patchcoind" ]; then
  mkdir -p "$PTC_DATA"
  chmod 700 "$PTC_DATA"
  chown -R patchcoin "$PTC_DATA"

  if [[ ! -s "$PTC_DATA/patchcoin.conf" ]]; then
    cat <<-EOF > "$PTC_DATA/patchcoin.conf"
	test.rpcbind=0.0.0.0
	main.rpcbind=0.0.0.0
	rpcallowip=::/0
	rpcpassword=${RPC_PASSWORD}
	rpcuser=${RPC_USER}
	EOF
    chown patchcoin "$PTC_DATA/patchcoin.conf"
  fi

  set -- "$@" -datadir="$PTC_DATA"
fi

if [ "$1" = "patchcoind" ] || [ "$1" = "patchcoin-cli" ] || [ "$1" = "patchcoin-tx" ] || [ "$1" = "patchcoin-wallet" ] || [ "$1" = "patchcoin-util" ]; then
  exec gosu patchcoin "$@"
fi

exec "$@"
