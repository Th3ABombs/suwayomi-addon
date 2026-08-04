ARG BUILD_FROM
FROM ${BUILD_FROM}

USER root
RUN if command -v apk >/dev/null 2>&1; then apk add --no-cache jq; \
    elif command -v apt-get >/dev/null 2>&1; then apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*; \
    else echo "No supported package manager found"; exit 1; fi

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
