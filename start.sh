#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Backend Setup ---
JAR_FILE="target/shareit-1.0-SNAPSHOT.jar"

if [ ! -f "$JAR_FILE" ]; then
    echo "JAR file not found. Building the backend..."
    mvn clean install
else
    echo "JAR file found. Skipping build."
fi

echo "Starting the backend..."
java -jar $JAR_FILE &

# --- Wait for Backend ---
echo "Waiting for backend to start on port 8080..."
while ! nc -z localhost 8080; do
  sleep 1
done
echo "Backend is up and running!"

# --- Frontend Setup ---
# The commands inside the parentheses run in a subshell
(
  echo "Changing to client directory and starting frontend..."
  cd client

  if [ ! -d "node_modules" ]; then
      echo "node_modules not found. Running npm install..."
      npm install
  else
      echo "node_modules found. Skipping npm install."
  fi

  npm run dev
)

echo "Startup complete! Both frontend and backend are running."