FROM ruby:2.7-slim-buster

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends vim postgresql-client libpq-dev tzdata \
locales imagemagick build-essential curl git sqlite3 libsqlite3-dev

ENV NODE_VERSION 12
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

RUN apt-get install -y --no-install-recommends nodejs
RUN npm install -g yarn
RUN yarn install --check-files

WORKDIR /tmp

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LC_ALL en_US.utf8

RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata

WORKDIR /origin-test
COPY Gemfile /origin-test/Gemfile
COPY Gemfile.lock /origin-test/Gemfile.lock

RUN bundle install --jobs 20 --retry 5
RUN gem install bundle-audit

ADD . /origin-test
COPY . /origin-test

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
