FROM ruby:3.3.6-alpine3.20

COPY .build-deps /
RUN apk add --no-cache $(cat .build-deps)

WORKDIR /usr/src/app

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY Gemfile* ./
RUN bundle install --jobs 20 --retry 5

COPY . .

CMD bundle exec rails s --binding 0.0.0.0
EXPOSE 3000
