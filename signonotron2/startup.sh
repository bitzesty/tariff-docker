#!/bin/bash
service postfix start

export RAILS_ENV=docker
bundle install
bundle exec rake docker:tariff_applications
bundle exec ./script/make_oauth_work_in_dev
bundle exec foreman start
exit 0
