from flask import Blueprint, jsonify

petfinder_bp = Blueprint("petfinder", __name__)

@petfinder_bp.route("/pets")
def get_pets():
    return jsonify([
        {"id": 1, "name": "Whiskers"},
        {"id": 2, "name": "Barky"},
    ])