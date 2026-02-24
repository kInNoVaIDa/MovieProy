from flask_marshmallow import Marshmallow
from marshmallow import Schema, fields

class MovieScheme(Schema):
    title = fields.Str(required=True)
    year = fields.Int(required=True)
    duration = fields.Int(required=True)


movie_schema = MovieScheme()

