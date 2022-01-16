FROM ruby:2.6.3
# update yarn repo
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
# update node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /myapp

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the layers with gems
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
# Install latest bundler
RUN gem install bundler
RUN bundle install

# Copy the main application. Not needed when using volumes
COPY . ./

RUN bundle exec rake assets:precompile

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


