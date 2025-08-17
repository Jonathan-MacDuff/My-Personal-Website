import os

class Config:
    # Use DATABASE_URL from Render environment, fallback to SQLite for local dev
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'sqlite:///app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-me')
    JSON_SORT_KEYS = False
    
    # Session configuration for cross-origin requests
    SESSION_COOKIE_SECURE = True  # Required for SameSite=None
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'None'  # Allow cross-site cookies
    SESSION_PERMANENT = False