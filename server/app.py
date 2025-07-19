from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
# from config import Config
from flask_cors import CORS

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'  # or your real DB URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = '123'  # optional but recommended
# app.config.from_object(Config)

CORS(app)
db = SQLAlchemy()
db.init_app(app)
migrate = Migrate(app, db)

from server.models.petfinder import * 

from server.routes.petfinder import petfinder_bp
app.register_blueprint(petfinder_bp, url_prefix="/api/petfinder")

if __name__ == "__main__":
    app.run(debug=True)



__all__ = ['app', 'db']