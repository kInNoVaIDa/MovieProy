from pymongo import MongoClient
import os

MONGO_URI = os.getenv("MONGO_URI", "mongodb://admin:password123@localhost:27017/")

client = MongoClient(MONGO_URI)
db = client["movies_db"]
movies_coll =   db["movies"]