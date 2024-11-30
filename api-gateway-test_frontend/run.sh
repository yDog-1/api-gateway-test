#!/bin/bash -x

[ ! -d '/tmp/cache' ] && mkdir -p /tmp/cache

exec bun run --bun server.js
