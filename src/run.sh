#!/bin/bash
set -e

find /coin/data/ -type d -not -path /coin/data/ -print0 | xargs -r -0 chmod -v 700
[ "$(ls -A /coin/data)" ] && find /coin/data -type f -print0 | xargs -0 chmod -v 600 || echo "Empty"

sed -i "s/rpcport=.*/rpcport=${RPC_PORT}/" /coin/coin.conf
sed -i "s/rpcuser=.*/rpcuser=${RPC_USER}/" /coin/coin.conf
sed -i "s/rpcpassword=.*/rpcpassword=${RPC_PASS}/" /coin/coin.conf
sed -i "s/tcp:\/\/0.0.0.0:.*/tcp:\/\/0.0.0.0:${WS_PORT}/g" /coin/coin.conf
sed -i "s/^port=.*/port=${P2P_PORT}/" /coin/coin.conf

exec ./bitcoind \
    -datadir=/coin/data \
    -conf=/coin/coin.conf \
    $@
