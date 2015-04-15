FROM macool/baseimage-rbenv-docker:latest

RUN apt-get -qq update
RUN apt-get -qqy upgrade

# Update rbenv and ruby-build definitions
RUN bash -c 'cd /root/.rbenv && git pull'
RUN bash -c 'cd /root/.rbenv/plugins/ruby-build && git pull'

# Install ruby and gems
RUN rbenv install 2.2.2
RUN rbenv global 2.2.2

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler
RUN rbenv rehash

# make sure we have libmysqlclient-dev
RUN apt-get install -qqy libmysqlclient-dev

# install mysql-client (will be used by `db:create` task)
RUN apt-get install -qqy mysql-client

# install postfix
RUN apt-get -qq upgrade && apt-get -qqy install postfix

# clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME
# and workdir
RUN mkdir /signonotron2
WORKDIR /signonotron2

# let's copy and bundle
ADD . /signonotron2
RUN bundle install

# add tariff IPs
RUN mkdir -p /etc/my_init.d
ADD tariff_ips.sh /etc/my_init.d/tariff_ips.sh
RUN chmod +x /etc/my_init.d/tariff_ips.sh
