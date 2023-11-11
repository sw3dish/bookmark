FROM elixir:1.15.7
MAINTAINER Colin Burr <colin@colin.id>

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y inotify-tools \
                                            ca-certificates \
                                            curl \
                                            gnupg
# Install node
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

ENV NODE_MAJOR=20

RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install -y nodejs

# Install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Install Phoenix
RUN mix archive.install hex phx_new 1.7.10 --force

COPY . /srv/www

WORKDIR /srv/www/bookmark

# Install Elixir dependencies
RUN mix deps.get

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

