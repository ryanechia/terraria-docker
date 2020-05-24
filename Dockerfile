FROM ubuntu:18.04 AS builder

MAINTAINER Ryane Chia <ryanechia@outlook.com>

WORKDIR /opt

RUN apt-get update \
    && apt-get install -y unzip wget

ARG VERSION=1402
# uncomment when latest version reverts back to normal URL format
#ARG SERVER_ZIP_URL='http://terraria.org/server/terraria-server-${VERSION}.zip'
#ADD ${SERVER_ZIP_URL} terraria-server.zip
RUN wget -O terraria-server.zip https://terraria.org/system/dedicated_servers/archives/000/000/036/original/terraria-server-1402.zip?1589675482

RUN unzip terraria-server.zip "${VERSION}/Linux/*" \
  && chmod -R a+rw ${VERSION}/Linux/* \
  && chmod a+x ${VERSION}/Linux/TerrariaServer* \
  && mv ${VERSION}/Linux terraria/

# Stage 2
FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install -y screen

WORKDIR /opt/terraria

COPY --from=builder /opt/terraria .

VOLUME ["/world"]
EXPOSE 7777

ADD serverconfig.txt .
ADD terrariad /usr/local/bin/terrariad
RUN chmod +x /usr/local/bin/terrariad

ENTRYPOINT systemctl start terraria
