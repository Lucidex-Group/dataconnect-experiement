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

# --- Define 20 movies ---
MOVIES=(
'{"title": "Die Hard", "genre": "Action", "imageUrl": "https://example.com/diehard.jpg"}'
'{"title": "The Matrix", "genre": "Sci-Fi", "imageUrl": "https://example.com/thematrix.jpg"}'
'{"title": "Inception", "genre": "Sci-Fi", "imageUrl": "https://example.com/inception.jpg"}'
'{"title": "Pulp Fiction", "genre": "Crime", "imageUrl": "https://example.com/pulpfiction.jpg"}'
'{"title": "The Godfather", "genre": "Crime", "imageUrl": "https://example.com/godfather.jpg"}'
'{"title": "Forrest Gump", "genre": "Drama", "imageUrl": "https://example.com/forrestgump.jpg"}'
'{"title": "Gladiator", "genre": "Action", "imageUrl": "https://example.com/gladiator.jpg"}'
'{"title": "Titanic", "genre": "Romance", "imageUrl": "https://example.com/titanic.jpg"}'
'{"title": "Avatar", "genre": "Sci-Fi", "imageUrl": "https://example.com/avatar.jpg"}'
'{"title": "The Shawshank Redemption", "genre": "Drama", "imageUrl": "https://example.com/shawshank.jpg"}'
'{"title": "Interstellar", "genre": "Sci-Fi", "imageUrl": "https://example.com/interstellar.jpg"}'
'{"title": "The Dark Knight", "genre": "Action", "imageUrl": "https://example.com/darkknight.jpg"}'
'{"title": "Jurassic Park", "genre": "Adventure", "imageUrl": "https://example.com/jurassicpark.jpg"}'
'{"title": "Rocky", "genre": "Sports", "imageUrl": "https://example.com/rocky.jpg"}'
'{"title": "Casablanca", "genre": "Romance", "imageUrl": "https://example.com/casablanca.jpg"}'
'{"title": "Star Wars", "genre": "Sci-Fi", "imageUrl": "https://example.com/starwars.jpg"}'
'{"title": "The Lord of the Rings", "genre": "Fantasy", "imageUrl": "https://example.com/lotr.jpg"}'
'{"title": "Back to the Future", "genre": "Sci-Fi", "imageUrl": "https://example.com/backtothefuture.jpg"}'
'{"title": "Terminator 2", "genre": "Action", "imageUrl": "https://example.com/terminator2.jpg"}'
'{"title": "The Silence of the Lambs", "genre": "Thriller", "imageUrl": "https://example.com/silenceofthelambs.jpg"}'
)

# --- Define 20 albums ---
ALBUMS=(
'{"name": "Abbey Road", "artist": "The Beatles"}'
'{"name": "Thriller", "artist": "Michael Jackson"}'
'{"name": "Back in Black", "artist": "AC/DC"}'
'{"name": "Rumours", "artist": "Fleetwood Mac"}'
'{"name": "The Dark Side of the Moon", "artist": "Pink Floyd"}'
'{"name": "Hotel California", "artist": "Eagles"}'
'{"name": "Led Zeppelin IV", "artist": "Led Zeppelin"}'
'{"name": "Sgt. Pepper’s Lonely Hearts Club Band", "artist": "The Beatles"}'
'{"name": "Nevermind", "artist": "Nirvana"}'
'{"name": "Born in the U.S.A.", "artist": "Bruce Springsteen"}'
'{"name": "The Joshua Tree", "artist": "U2"}'
'{"name": "Appetite for Destruction", "artist": "Guns N’ Roses"}'
'{"name": "Purple Rain", "artist": "Prince"}'
'{"name": "The Wall", "artist": "Pink Floyd"}'
'{"name": "OK Computer", "artist": "Radiohead"}'
'{"name": "Achtung Baby", "artist": "U2"}'
'{"name": "21", "artist": "Adele"}'
'{"name": "Goodbye Yellow Brick Road", "artist": "Elton John"}'
'{"name": "Metallica (The Black Album)", "artist": "Metallica"}'
'{"name": "Legend", "artist": "Bob Marley & The Wailers"}'
)

# Function to pick a random element from an array
pick_random() {
  local arr=("$@")
  local len=${#arr[@]}
  local index=$(( RANDOM % len ))
  echo "${arr[$index]}"
}

# Pick a random movie and album
RANDOM_MOVIE=$(pick_random "${MOVIES[@]}")
RANDOM_ALBUM=$(pick_random "${ALBUMS[@]}")


# --- Dataconnect Functions Calls ---

echo "---------------------------------------------------"
echo ">>> Testing DATACONNECT by adding MOVIE DETAILS <<<"
echo ""
echo "Randomly selected movie payload:"
echo "$RANDOM_MOVIE" | jq .
echo ""
echo "---------------------------------------------------"
echo ""

echo "Calling dataconnect_httpFetchMovies..."
curl -s -X GET "$BASE_URL/dataconnect_httpFetchMovies" | jq .
echo -e "\n\n"

echo "Calling dataconnect_httpFetchMoviesViaQueryRef..."
curl -s -X GET "$BASE_URL/dataconnect_httpFetchMoviesViaQueryRef" | jq .
echo -e "\n\n"

echo "Calling dataconnect_httpAddMovie..."
curl -s -X POST "$BASE_URL/dataconnect_httpAddMovie" \
  -H "Content-Type: application/json" \
  -d "$RANDOM_MOVIE" | jq .
echo -e "\n\n"

# --- Firestore Functions Calls ---

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++ Testing FIRESTORE by adding ALBUM DETAILS +++"
echo ""
echo "Randomly selected album payload:"
echo "$RANDOM_ALBUM" | jq .
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""

echo "Calling firestore_httpAddAlbum..."
curl -s -X POST "$BASE_URL/firestore_httpAddAlbum" \
  -H "Content-Type: application/json" \
  -d "$RANDOM_ALBUM" | jq .
echo -e "\n\n"

echo "Calling firestore_httpListAlbums..."
curl -s -X GET "$BASE_URL/firestore_httpListAlbums" | jq .
echo -e "\n\n"