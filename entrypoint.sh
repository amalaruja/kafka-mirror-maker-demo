#!/bin/bash

cd /opt/Kafka/config

# set consumer properties
envsubst < "consumer.properties" > "temp"
cat temp > consumer.properties

# set producer properties
envsubst < "producer.properties" > "temp"
cat temp > producer.properties

# configure logging properties
envsubst < "tools-log4j.properties" > "temp"
cat temp > tools-log4j.properties

rm temp
cd ../

# start mirror maker
bin/kafka-run-class.sh kafka.tools.MirrorMaker \
--consumer.config config/consumer.properties \
--producer.config config/producer.properties \
--num.streams $NUM_STREAMS \
--whitelist $WHITELISTED_TOPICS