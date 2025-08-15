#!/bin/bash

set -e  # Exit on any error

echo "Pet Finder Database Setup"
echo "=========================="

# Navigate to server
cd ../server

# Run migration
echo "Running database migration..."
python -c "
import sys
import os
sys.path.insert(0, os.getcwd())
from app import app
from petfinder.extensions import migrate
with app.app_context():
    from flask_migrate import upgrade
    upgrade()
"

if [ $? -eq 0 ]; then
    echo "✓ Migration completed successfully"
else
    echo "✗ Migration failed"
    exit 1
fi

# Ask about seeding
echo
read -p "Do you want to run the seed script? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Running seed script..."
    python -m petfinder.seed
    
    if [ $? -eq 0 ]; then
        echo "✓ All operations completed successfully!"
    else
        echo "✗ Seeding failed"
        exit 1
    fi
else
    echo "Skipping seed script"
    echo "✓ Migration completed successfully!"
fi