from flask import jsonify, request, Flask
from service.mongo import movies_coll
from service.rabbitmq import publish_message
from pymongo.errors import ConnectionFailure 
from models.schema import movie_schema
from marshmallow import ValidationError

app = Flask(__name__)

@app.route("/movies", methods = ["POST"])
def createMovie():
    json_data = request.json
    if not json_data:
        return jsonify({"erro", "No json provided"}), 400

    try:
        data = movie_schema.load(json_data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    publish_message(data)

    return jsonify({"message": "pelicula enviada"}), 202
#===========================================================

@app.route("/movies", methods = ["GET"])
def getMovies():
    try:
        movies = list(movies_coll.find({}, {"_id": 0}))
        return jsonify(movies)
    except ConnectionFailure:
        return jsonify({"error": "database connection failed"}), 500

@app.route("/movies/<title>", methods = ["GET"])
def getMovie(title: str):
    movie = movies_coll.find_one({"title": title}, {"_id": 0})

    if not movie:
        return jsonify({"error": "movie not found"}), 404
    return jsonify(movie)
@app.route("/movies/<title>", methods = ["PUT"])
def updateMovie(title: str):
    data = request.json

    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    result = movies_coll.update_one( {"title": title}, {"$set": data} )

    if result.matched_count == 0:
        return jsonify({"error": "movie not found"}), 404

    return jsonify({"message": "movie updated"})

@app.route("/movies/<title>", methods = ["DELETE"])
def deleteMovie(title: str):
    result = movies_coll.delete_one({"title": title})

    if result.deleted_count == 0:
        return jsonify({"error": "movie not found"}), 404

    return jsonify({"message": "movie deleted"})

if __name__ == "__main__":
    app.run(host ="0.0.0.0", port=5000, debug=True)