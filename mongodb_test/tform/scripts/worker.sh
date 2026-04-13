#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker

# Login a ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 306970076789.dkr.ecr.us-east-1.amazonaws.com

# Obtener IPs del Parameter Store
RABBITMQ_IP=$(aws ssm get-parameter --name "/movies/rabbitmq_ip" --query 'Parameter.Value' --output text --region us-east-1)
MONGO_IP=$(aws ssm get-parameter --name "/movies/mongo_ip" --query 'Parameter.Value' --output text --region us-east-1)

docker run -d \
  --name worker_service \
  -e RABBITMQ_HOST=$RABBITMQ_IP \
  -e RABBITMQ_USER=user \
  -e RABBITMQ_PASS=password \
  -e MONGO_URI=mongodb://admin:password123@$MONGO_IP:27017/?authSource=admin \
  306970076789.dkr.ecr.us-east-1.amazonaws.com/mongodb_test-worker:latest python3 worker.py