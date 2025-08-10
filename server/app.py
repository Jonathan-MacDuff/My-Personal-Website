from dotenv import load_dotenv
load_dotenv()
from flask import Flask, request, jsonify
from email_utils import send_contact_email
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": [
    "https://autistic-insight.com",
    "https://www.autistic-insight.com"
]}})

@app.route('/')
def index():
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

if __name__ == "__main__":
    app.run(debug=True)