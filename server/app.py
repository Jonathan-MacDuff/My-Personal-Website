from dotenv import load_dotenv
load_dotenv()
from flask import Flask, request, jsonify, send_from_directory
from email_utils import send_contact_email
from flask_cors import CORS
from catmemes.app import catmemes_bp
from petfinder.routes import petfinder_bp
from petfinder.extensions import db, migrate, socketio
from petfinder.config import Config

app = Flask(__name__, static_folder=None)

app.config.from_object(Config)

app.register_blueprint(catmemes_bp, url_prefix="/catmemes")
app.register_blueprint(petfinder_bp, url_prefix="/petfinder")

db.init_app(app)
migrate.init_app(app, db)

socketio.init_app(app, cors_allowed_origins="*", transports=["polling"])
import petfinder.socketio_handlers

CORS(app, resources={r"/api/*": {"origins": [
    "https://autistic-insight.com",
    "https://www.autistic-insight.com"
]}})

@app.route('/')
def index():
    print("🟢 Main index route hit")
    return 'OK', 200

@app.route("/api/contact", methods=["POST"])
def contact():
    data = request.get_json()
    name = data.get("name")
    phone = data.get("phone", "")
    email = data.get("email")
    message = data.get("message")
    contact_methods = data.get("contactMethods", {})

    if not name or not email or not message:
        return jsonify({"error": "Name, email, and message are required"}), 400

    try:
        send_contact_email(name, phone, email, message, contact_methods)
        return jsonify({"message": "Email sent successfully!"}), 200
    except Exception as e:
        print("Email error:", e)
        return jsonify({"error": "Email failed to send"}), 500

# Pet-Finder SPA routes - order matters!
# Most specific routes first, then catch-all

# Serve Pet-Finder static assets (CSS, JS)
@app.route('/Pet-Finder/static/<path:filename>')
def serve_pet_finder_static(filename):
    print(f"🟦 Serving static asset: /Pet-Finder/static/{filename}")
    return send_from_directory('static/pet-finder/static', filename)

# Main Pet-Finder routes
@app.route('/Pet-Finder', strict_slashes=False)
@app.route('/Pet-Finder/', strict_slashes=False)
def serve_pet_finder_root():
    print("🟩 Serving Pet-Finder root")
    return send_from_directory('static/pet-finder', 'index.html')

# Catch-all for Pet-Finder SPA routes (must be last)
@app.route('/Pet-Finder/<path:path>', strict_slashes=False)
def serve_pet_finder_spa(path):
    print(f"🟨 Pet-Finder SPA route: /Pet-Finder/{path}")
    # Check if it's a static asset file (favicon, manifest, etc.)
    if '.' in path and '/' not in path:
        print(f"🟧 Trying to serve asset: {path}")
        try:
            return send_from_directory('static/pet-finder', path)
        except:
            print(f"🟥 Asset not found: {path}")
            pass
    # For all SPA routes, serve index.html
    print(f"🟪 Serving index.html for SPA route: {path}")
    return send_from_directory('static/pet-finder', 'index.html')

# Add request logging middleware
@app.before_request
def log_request():
    print(f"🌐 Flask received: {request.method} {request.path}")

# Debug catch-all to see what requests are actually hitting Flask
@app.route('/<path:path>')
def catch_all_debug(path):
    print(f"🔍 Catch-all debug: Flask received request for /{path}")
    return f"Debug: Flask received /{path}", 404

if __name__ == "__main__":
    socketio.run(app, debug=True)