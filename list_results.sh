#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install jq (e.g., using 'brew install jq' on macOS) and then re-run the script."
  exit 1
fi

# Base URL for local functions emulator (adjust if needed)
BASE_URL="http://127.0.0.1:5001/dataconnect-experiment/us-central1"

# Warn the user to verify the BASE_URL
echo "WARNING: The BASE_URL is set to \"$BASE_URL\". Please ensure this is correct before proceeding."
echo ""

# --- DATACONNECT LIST FUNCTIONS ---
echo "----------------------------------------------------"
echo ">>> Testing DATACONNECT LIST FUNCTIONS (Movies) <<<"
echo "----------------------------------------------------"
echo ""

echo "Calling dataconnect_httpFetchMovies..."
curl -s -X GET "$BASE_URL/dataconnect_httpFetchMovies" | jq .
echo -e "\n\n"

echo "Calling dataconnect_httpFetchMoviesViaQueryRef..."
curl -s -X GET "$BASE_URL/dataconnect_httpFetchMoviesViaQueryRef" | jq .
echo -e "\n\n"

# --- FIRESTORE LIST FUNCTIONS ---
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ Testing FIRESTORE LIST FUNCTION (Albums) +++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""

echo "Calling firestore_httpListAlbums..."
curl -s -X GET "$BASE_URL/firestore_httpListAlbums" | jq .
echo -e "\n\n"