FROM ubuntu:20.04

ARG KAFKA_VERSION=2.4.1
ARG SCALA_VERSION=2.11
ARG BINARY_NAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}"
ARG BINARY_TAR_NAME="${BINARY_NAME}.tgz"
ARG BINARY_ASC_NAME="${BINARY_TAR_NAME}.asc"
ARG BINARY_URI="https://mirrors.estointernet.in/apache/kafka/${KAFKA_VERSION}/${BINARY_TAR_NAME}"
ARG BINARY_ASC_URI="https://downloads.apache.org/kafka/${KAFKA_VERSION}/${BINARY_ASC_NAME}"

RUN apt-get -qq update
RUN apt-get install -qq wget -y > /dev/null
RUN apt-get install -qq gpg -y > /dev/null
RUN apt-get install -qq gettext -y > /dev/null
RUN apt-get install -qq openjdk-8-jre -y > /dev/null
RUN wget -nv $BINARY_URI
RUN wget -nv $BINARY_ASC_URI
RUN wget -nv https://downloads.apache.org/kafka/KEYS
RUN gpg --import KEYS
RUN gpg --verify $BINARY_ASC_NAME $BINARY_TAR_NAME
RUN mkdir -p /opt/Kafka
RUN tar xzf $BINARY_TAR_NAME -C /opt
RUN mv /opt/$BINARY_NAME/* /opt/Kafka
RUN rm $BINARY_TAR_NAME $BINARY_ASC_NAME KEYS

WORKDIR "/opt/Kafka/"
COPY --chown=600 config config
COPY --chown=755 entrypoint.sh ./
RUN chmod +x entrypoint.sh

ENTRYPOINT ./entrypoint.sh