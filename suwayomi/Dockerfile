FROM ghcr.io/suwayomi/suwayomi-server:stable

USER root

RUN if command -v apk >/dev/null 2>&1; then \
      apk add --no-cache nginx jq; \
    elif command -v apt-get >/dev/null 2>&1; then \
      apt-get update && apt-get install -y nginx jq && rm -rf /var/lib/apt/lists/*; \
    else \
      echo "No supported package manager found"; exit 1; \
    fi

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf


RUN chmod +x /run.sh

CMD ["/run.sh"]
