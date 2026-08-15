ARG BUILD_FROM
FROM ${BUILD_FROM}

# The upstream image already contains the app and its runtime; we only add
# the glue needed to translate Home Assistant's /data/options.json into the
# environment variables Quaestor expects.
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
