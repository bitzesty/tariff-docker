#!/bin/sh
BACKEND_HOST=tariff-api.dev.gov.uk
ADMIN_HOST=tariff-admin.dev.gov.uk

echo "$BACKEND_1_PORT_3018_TCP_ADDR $BACKEND_HOST" >> /etc/hosts
echo "$ADMIN_1_PORT_3046_TCP_ADDR $ADMIN_HOST" >> /etc/hosts
