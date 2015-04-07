#!/bin/bash
export RAILS_ENV=docker
bundle install
GDS_SSO_STRATEGY=real bundle exec unicorn -p 3046
