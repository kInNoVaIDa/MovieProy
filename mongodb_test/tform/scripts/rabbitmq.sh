#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker

docker run -d \
  --name rabbitmq_server \
  -p 5672:5672 \
  -p 15672:15672 \
  -e RABBITMQ_DEFAULT_USER=user \
  -e RABBITMQ_DEFAULT_PASS=password \
  -e RABBITMQ_ERLANG_COOKIE=secretcookie \
  rabbitmq:3.11-management