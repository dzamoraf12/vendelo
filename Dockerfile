# Dockerfile (development)
FROM ruby:3.3.9-slim

# OS deps
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libvips \
    curl \
    git \
    pkg-config \
    libyaml-dev \
  && rm -rf /var/lib/apt/lists/*

# Faster bundler
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /app

# Cache gems when only Gemfile changes
COPY Gemfile Gemfile.lock ./
RUN bundle install || true

# App code
COPY . .

# Entrypoint clears stale pids & ensures gems
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bash", "-lc", "bin/rails db:prepare && bin/rails s -p 3000 -b 0.0.0.0"]
