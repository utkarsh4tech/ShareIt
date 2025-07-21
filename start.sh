#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Backend Setup ---
echo "Building and starting the backend..."

# Build the Maven project
mvn clean install

# Run the backend application in the background
java -jar target/shareit-1.0-SNAPSHOT.jar &

# --- Wait for Backend ---
echo "Waiting for backend to start on port 8080..."
while ! nc -z localhost 8080; do
  sleep 1 # wait for 1 second before checking again
done

# --- Frontend Setup ---

echo "Starting the frontend..."
# Navigate to the client directory
cd client

# Install frontend dependencies
npm install

# Start the Next.js development server
npm run dev

echo "Startup complete! Backend is running in the background and frontend is running."