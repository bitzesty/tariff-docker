#!/bin/bash
bundle install
bundle exec rake docker:tariff_applications
bundle exec ./script/make_oauth_work_in_dev
bundle exec rails s -p 3016
