import pika
import json
import os
from service.mongo import movies_coll
from service.rabbitmq import get_connection

RABBITMQ_HOST = os.getenv("RABBITMQ_HOST", "localhost")
QUEUE_NAME = "movies_queue"

def callBack(ch, method, parameters, body):
    movie = json.loads(body)

    print("Recived", movie)

    movies_coll.insert_one(movie)

    ch.basic_ack(delivery_tag = method.delivery_tag)


def startWorker():
    connection = get_connection()
    channel = connection.channel()

    channel.queue_declare(queue=QUEUE_NAME, durable= True)

    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue=QUEUE_NAME, on_message_callback= callBack)
    print("Worker waiting for messages")

    channel.start_consuming()

if __name__ == "__main__":
    startWorker()