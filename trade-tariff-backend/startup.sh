#!/bin/bash
export RAILS_ENV=docker
export GDS_SSO_STRATEGY=real

bundle install
bundle exec whenever --update-crontab
bundle exec foreman start
exit 0
