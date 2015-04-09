#!/bin/sh
BACKEND_HOST=tariff-api.tariff.dev.bitzesty.com
SIGNONOTRON2_HOST=signon.tariff.dev.bitzesty.com

echo "$BACKEND_1_PORT_3018_TCP_ADDR $BACKEND_HOST" >> /etc/hosts
echo "$SIGNONOTRON2_1_PORT_3016_TCP_ADDR $SIGNONOTRON2_HOST" >> /etc/hosts
