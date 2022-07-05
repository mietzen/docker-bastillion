FROM mietzen/dockerize:latest AS dockerize
FROM eclipse-temurin:17-jre
LABEL maintainer="Nils Stein <social.nstein@mailbox.org>"

ARG BASTILLION_VERSION
ARG BASTILLION_FILENAME_VERSION

ENV BASTILLION_VERSION=${BASTILLION_VERSION} \
    BASTILLION_FILENAME=${BASTILLION_FILENAME_VERSION}

RUN apt-get update && apt-get dist-upgrade -y

ADD https://github.com/bastillion-io/Bastillion/releases/download/v${BASTILLION_VERSION}/bastillion-jetty-v${BASTILLION_FILENAME}.tar.gz /tmp/

COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin

RUN tar xzf /tmp/bastillion-jetty-v${BASTILLION_FILENAME}.tar.gz -C /opt && \
    mv /opt/Bastillion-jetty /opt/bastillion && \
    rm /tmp/bastillion-jetty-v${BASTILLION_FILENAME}.tar.gz && \
    mkdir /opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb && \
    ln -s /opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb /keydb && \
    rm /opt/bastillion/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties

ADD files/BastillionConfig.properties.tpl /opt
ADD files/jetty-start.ini /opt/bastillion/jetty/start.ini
ADD files/startBastillion.sh /opt/bastillion/startBastillion.sh

RUN useradd --system --no-create-home --user-group --home-dir /opt/bastillion --shell /bin/bash --uid 999 bastillion && \
    chmod 755 /opt/bastillion/startBastillion.sh && \
    chown -R 999:999 /opt/bastillion && \
    chmod -R g=u /opt/bastillion

VOLUME /keydb
WORKDIR /opt/bastillion
EXPOSE 8443
USER 999

ENTRYPOINT ["/usr/local/bin/dockerize"]
CMD ["-template", \
     "/opt/BastillionConfig.properties.tpl:/opt/bastillion/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties", \
     "/opt/bastillion/startBastillion.sh"]
