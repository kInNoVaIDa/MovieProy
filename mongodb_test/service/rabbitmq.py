import pika
import os
import json

RABBITMQ_HOST = os.getenv("RABBITMQ_HOST", "localhost")
QUEUE_NAME = "movies_queue"


def get_connection():
    credentials = pika.PlainCredentials("user", "password")
    parameters = pika.ConnectionParameters(
        host= RABBITMQ_HOST,
        port= 5672,
        credentials=credentials 
    )
    return pika.BlockingConnection(parameters)

def publish_message(message: dict):
    connection = get_connection()
    channel = connection.channel()

    channel.queue_declare(queue=QUEUE_NAME, durable=True)

    channel.basic_publish(
        exchange="",
        routing_key=QUEUE_NAME,
        body=json.dumps(message)
    )

    connection.close()