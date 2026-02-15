from pymongo import MongoClient
from flask import jsonify, request, Flask
from pymongo.errors import ConnectionFailure

app = Flask(__name__)

client = MongoClient("mongodb://admin:password123@localhost:27017/admin")

@app.route('/')
def home():
    return jsonify({"message": "funca"})


@app.route('/ping')
def ping_db():
    try: 
        client.admin.command("ping")
        return jsonify({"status": "mongo conectado"})
    except ConnectionFailure:
        return jsonify({"status": "error conectando"}), 500








if __name__ == "__main__":
    app.run(debug=True)
