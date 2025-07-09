FROM alpine:latest

WORKDIR /git-repo

RUN apk update && apk add --no-cache git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh  && mkdir -p /root/.ssh

ENTRYPOINT ["/entrypoint.sh"]
