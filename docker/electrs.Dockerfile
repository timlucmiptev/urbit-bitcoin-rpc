FROM rust:1.44.1-slim-buster

RUN apt-get update \
  && apt-get install -y --no-install-recommends clang=1:7.* cmake=3.* \
     libsnappy-dev=1.* \
     netcat curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-login --system --shell /bin/false --uid 1000 user

WORKDIR /home/user
COPY ./electrs /home/user
RUN chown -R user .

USER user

RUN cargo install --path .

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT