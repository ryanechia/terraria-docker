FROM ubuntu:18.04 AS builder

MAINTAINER Ryane Chia <ryanechia@outlook.com>

WORKDIR /var

RUN apt-get update \
    && apt-get install -y unzip wget

ARG VERSION=1404
# uncomment when latest version reverts back to normal URL format
#ARG SERVER_ZIP_URL='http://terraria.org/server/terraria-server-${VERSION}.zip'
#RUN wget -O terraria-server.zip ${SERVER_ZIP_URL}
RUN wget -O terraria-server.zip https://www.terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-1404.zip?1590253816

RUN unzip terraria-server.zip "${VERSION}/Linux/*" \
  && chmod -R a+rw ${VERSION}/Linux/* \
  && chmod a+x ${VERSION}/Linux/TerrariaServer* \
  && mv ${VERSION}/Linux terraria/

# Stage 2
FROM ubuntu:18.04
#RUN apt-get update \
#    && apt-get install -y screen
#    && apt-get install -y tmux

WORKDIR /var/terraria

COPY --from=builder /var/terraria .

VOLUME ["/world"]
EXPOSE 7777

ADD serverconfig.txt .
ADD server-start.sh .
RUN chmod +x server-start.sh
#ADD terrariad /usr/local/bin/terrariad
#RUN chmod +x /usr/local/bin/terrariad

#ENTRYPOINT screen -dmS terraria /bin/sh -c "./TerrariaServer -x64 -config serverconfig.txt"
#ENTRYPOINT tmux new -d -s terraria-session './TerrariaServer -x64 -config serverconfig.txt' \; \
#            attach \;
ENTRYPOINT ["./server-start.sh"]
CMD ["run"]
