# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=alpine
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20220801-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.14.1-erlang-25.0.4-debian-bullseye-20220801-slim
#
ARG ELIXIR_VERSION=1.17.1
ARG OTP_VERSION=27.0
ARG ALPINE_VERSION=3.20.1

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apk upgrade --no-cache
RUN apk add --no-cache build-base git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
	mix local.rebar --force

# set build ENV
ENV MIX_ENV prod

# install mix dependencies
RUN mkdir config && touch config/compiletime.exs
COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.

COPY config/config.exs config/$MIX_ENV.exs config/
# COPY config/compiletime.exs config/
# COPY config/compiletime/${MIX_ENV}.exs config/compiletime/

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
RUN mix deps.compile

COPY priv priv
COPY lib lib

# Compile the release
ARG APP_VERSION
RUN mix compile

# # Compile assets
# COPY assets assets
# RUN mix assets.deploy

# Generate docs that get served through the API
# COPY guides guides
# COPY docs docs
# COPY README.md ./
# RUN mix docs --output priv/docs

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/
# COPY config/runtime.exs config/
# COPY config/runtime config/runtime

# COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apk upgrade --no-cache
RUN apk add --no-cache libstdc++ openssl ncurses-libs postgresql-client

# Set the locale
RUN apk add --no-cache --virtual .build-deps
RUN apk add --no-cache icu-libs

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en 
ENV LC_ALL=en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV prod

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/hill_chart ./

#LABELS
LABEL org.opencontainers.image.source = "https://github.com/MathieuDR/hill-chart"
LABEL org.opencontainers.image.description="Hill chart stuff"

# Copy entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER nobody

ENTRYPOINT ["/app/entrypoint.sh"]
# CMD ["start"]
