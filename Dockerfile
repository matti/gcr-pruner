FROM google/cloud-sdk:alpine

COPY --from=mattipaksula/command2http /* /usr/bin

WORKDIR /app
COPY app .

ENV COMMAND=/app/pruner.sh
ENTRYPOINT [ "command2http" ]