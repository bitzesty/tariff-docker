#!/bin/bash
service postfix start

bundle install
bundle exec rake docker:tariff_applications
bundle exec ./script/make_oauth_work_in_dev
bundle exec foreman start
exit 0
