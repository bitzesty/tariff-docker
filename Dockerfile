FROM macool/baseimage-rbenv-docker:latest

# Update rbenv and ruby-build definitions
RUN bash -c 'cd /root/.rbenv && git pull'
RUN bash -c 'cd /root/.rbenv/plugins/ruby-build && git pull'

# Install ruby and gems
RUN rbenv install 2.1.4
RUN rbenv global 2.1.4

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler --no-ri --no-rdoc
RUN rbenv rehash

# update sources
RUN apt-get -qqy update

# make sure we have libcurl and libmysqlclient-dev
RUN apt-get install -qqy libcurl4-openssl-dev libmysqlclient-dev

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME
# and workdir
RUN mkdir /trade-tariff-backend
WORKDIR /trade-tariff-backend

# let's copy and bundle backend
ADD . /trade-tariff-backend
RUN bundle install
