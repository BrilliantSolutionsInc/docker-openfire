FROM openjdk:17-jdk-slim-bullseye

ENV OPENFIRE_VERSION=4.6.7 \
    OPENFIRE_USER=openfire \
    OPENFIRE_DATA_DIR=/var/lib/openfire \
    OPENFIRE_LOG_DIR=/var/log/openfire

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo wget fontconfig libfreetype6 \
 && echo "Downloading openfire_${OPENFIRE_VERSION}_all.deb ..." \
 && wget --no-verbose "http://download.igniterealtime.org/openfire/openfire_${OPENFIRE_VERSION}_all.deb" -O /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && dpkg -i --force-depends /tmp/openfire_${OPENFIRE_VERSION}_all.deb \
 && mv /var/lib/openfire/plugins/admin /usr/share/openfire/plugin-admin \
 && ln -s /usr/local/openjdk-17/bin/java /usr/bin/java \
 && rm -rf openfire_${OPENFIRE_VERSION}_all.deb \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3478/tcp 3479/tcp 5222/tcp 5223/tcp 5229/tcp 5275/tcp 5276/tcp 5262/tcp 5263/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp
VOLUME ["${OPENFIRE_DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
