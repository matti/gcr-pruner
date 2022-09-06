FROM google/cloud-sdk:alpine

COPY --from=mattipaksula/command2http@sha256:7098d883e70cd5895597b8a8a2da25618b2bec3847f64798a44b0badee34e0ca /* /usr/bin

WORKDIR /app
COPY app .

ENV COMMAND=/app/pruner.sh
ENTRYPOINT [ "command2http" ]
