FROM ubuntu:16.04

# Install Ruby and Rails dependencies
RUN apt-get update && apt-get install -y \
  nodejs \
  nodejs-legacy \
  nodejs-dev \
  npm \
  redis-server \
  rabbitmq-server

#enable guest user to connect from remote host
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

COPY . /hyperflow-master-monitor
WORKDIR /hyperflow-master-monitor

RUN npm install amqplib influxdb-nodejs aws-sdk

CMD service redis-server start && \
    service rabbitmq-server start && \
    ./cloudWatchMetricNotify.js 

EXPOSE 5672