ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.2.1
ARG DEBIAN_VERSION=bullseye-20231009-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
FROM ${BUILDER_IMAGE}

MAINTAINER Colin Burr <colin@colin.id>

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y inotify-tools \
                                            build-essential \
                                            ca-certificates \
                                            curl \
                                            gnupg \
                                            git
# Install node
RUN apt-get update && apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/sources.list.d /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install nodejs -y

# Install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Install Phoenix
RUN mix archive.install hex phx_new 1.7.10 --force

COPY . /srv/www

WORKDIR /srv/www/bookmark

# Install Elixir dependencies
RUN mix deps.get
RUN mix deps.compile

RUN npm install --prefix assets

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

