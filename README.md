# Dataconnect & Firestore Emulator Code Base

This repository contains a code base for testing interactions between Firebase Data Connect and Firestore using local emulators. The code includes Cloud Functions, generated SDK code, and several helper shell scripts.

## Table of Contents

- Prerequisites
- Firebase Project Setup
- Configuration
- Shell Scripts
  - kill_ports.sh
  - test_functions.sh
  - list_results.sh
- Switching Emulator Scenarios
- Usage
- Troubleshooting
- Questions

## Prerequisites

- **Node.js:** Ensure you have Node.js installed. (Note: Some packages require Node v22; however, your global version might be v18. Adjust as necessary.)


Firebase CLI: Install and update the Firebase CLI with:

```bash
npm install -g firebase-tools
```

- **jq:** A command-line JSON processor is required for shell scripts:

```bash
brew install jq
```

- **Git:** For version control and managing configuration changes.

Firebase Project Setup

Create a Firebase Project: Go to the Firebase Console (https://console.firebase.google.com/) and create a new project.

Enable Required APIs: Make sure to enable the following APIs in your project:

- Cloud Firestore
- Firebase Data Connect (if available or relevant to your experiment)

Get Your Project Keys: In your Firebase project settings, locate your web app’s configuration. This will include keys for apiKey, authDomain, projectId, storageBucket, messagingSenderId, and appId.

Update the Client App Initialization: In your Cloud Functions code (e.g., in dataconnect_index.js), update the initializeClientApp configuration:

    ```javascript
    const firebaseClientApp = initializeClientApp({
      apiKey: "YOUR_API_KEY",
      authDomain: "YOUR_PROJECT.firebaseapp.com",
      projectId: "YOUR_PROJECT_ID",
      storageBucket: "YOUR_PROJECT.appspot.com",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "YOUR_APP_ID"
    });
    ```

Replace the placeholder values with your actual Firebase project keys.

## Configuration

The repository contains several firebase.json configuration files to simulate different emulator scenarios:

- **firebase_only_firestore.json:** Runs only the Firestore emulator.
- **firebase_only_dataconnect.json:** Runs only the Data Connect emulator.
- **firebase_both_firestore_dataconnect.json:** Runs both Firestore and Data Connect emulators together.

To test a specific scenario:
1. Open the desired firebase.json file.
2. Copy its contents and paste them into your project’s root firebase.json file.
3. Restart the emulators using the Firebase CLI.

### Switching Emulator Scenarios

To simulate different environments, swap your firebase.json configuration:

- **Firestore Only:** Copy the contents of firebase_only_firestore.json into your root firebase.json.

- **Dataconnect Only:** Copy the contents of firebase_only_dataconnect.json into your root firebase.json.

- **Both Firestore & Dataconnect:** Copy the contents of firebase_both_firestore_dataconnect.json into your root firebase.json.

After swapping, restart your emulators with: firebase emulators:start

This allows you to test scenarios where only one service is running or both are running simultaneously.

Usage

### Start Emulators:

Ensure the appropriate firebase.json configuration is active.

Run:

Use the firebase extension in vscode to start the emulators

Run Shell Scripts:

Use ./kill_ports.sh to clear conflicting ports if needed.
Use ./test_functions.sh (or your list-only script) to call your Cloud Functions and view results.
View Emulator UI:

The emulator UI can be accessed (usually at http://127.0.0.1:4000) to inspect function endpoints, Firestore data, etc.
Troubleshooting

Authentication Errors: If you see errors like "unauthenticated: this operation requires a signed-in user with verified email," review your GraphQL schema and @auth directives. You may need to simulate an authenticated context for local testing.


## Shell Scripts

Three helper shell scripts are included to manage your local testing environment:

### kill_ports.sh

This script stops processes running on a set of common emulator ports.  
**Usage:**  
```bash
./kill_ports.sh
```

It iterates over a list of ports (e.g., 5001, 8080, 9399, etc.) and kills any process found on those ports. This is useful if you’re encountering port conflicts.


### test_functions.sh

This script calls the HTTP endpoints for your Cloud Functions. It selects a random movie payload from a list of 20 movies and a random album payload from a list of 20 albums, then calls the following endpoints:
	•	dataconnect_httpFetchMovies
	•	dataconnect_httpFetchMoviesViaQueryRef
	•	dataconnect_httpAddMovie
	•	firestore_httpAddAlbum
	•	firestore_httpListAlbums

Before running, ensure you have updated the BASE_URL variable if needed.

Usage:

```bash
./test_functions.sh
```

### list_results.sh (Optional)

If you have a similar script that only runs list functions (as described in your requirements), use it to test listing movies or albums independently.


### Questions

If you need additional information or run into issues that aren’t covered in this README, please ask! If there’s any file or configuration you’d like to review further, let me know.