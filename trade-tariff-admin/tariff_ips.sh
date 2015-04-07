#!/bin/sh
BACKEND_HOST=tariff-api.dev.gov.uk
SIGNONOTRON2_HOST=signon.dev.gov.uk

echo "$BACKEND_1_PORT_3018_TCP_ADDR $BACKEND_HOST" >> /etc/hosts
echo "$SIGNONOTRON2_1_PORT_3016_TCP_ADDR $SIGNONOTRON2_HOST" >> /etc/hosts
