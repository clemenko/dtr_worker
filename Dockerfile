FROM alpine

LABEL org.opencontainers.image.authors="clemenko@docker.com" \
      org.opencontainers.image.source="https://github.com/clemenko/dtr_worker/tree/master/demo_flask" \
      org.opencontainers.image.title="clemenko/dtr_worker" \
      org.opencontainers.image.description="The repository contains script to update the thread used by DTR on a replica. " 

RUN apk -U upgrade && apk add --no-cache curl jq bash ncurses && rm -rf /var/cache/apk/*
    
ADD . /
ENTRYPOINT [ "/dtr_worker.sh" ]
