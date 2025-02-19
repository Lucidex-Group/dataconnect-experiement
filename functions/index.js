// index.js (Cloud Functions entry point using ESM)
import functions from 'firebase-functions';
import admin from 'firebase-admin';
import { initializeApp as initializeClientApp } from 'firebase/app';
import http from 'http';
import {
  getDataConnect, 
  connectDataConnectEmulator, 
  executeQuery, 
  executeMutation 
} from 'firebase/data-connect';
import {
  createMovie,
  createMovieRef, 
  connectorConfig, 
  listMovies, 
  listMoviesRef 
} from '@firebasegen/default-connector';

// Initialize the Admin SDK.
admin.initializeApp();

// Initialize the Firebase client app with your config.
const firebaseClientApp = initializeClientApp({
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
});

// Create a Data Connect instance using your connector configuration and the client app.
const dataConnect = getDataConnect(connectorConfig, firebaseClientApp);

// (Optional) Connect to the local emulator if you're testing locally.
connectDataConnectEmulator(dataConnect, 'localhost', 9399);

/**
 * Helper function to check if a service is running.
 * It attempts an HTTP GET to the specified host and port.
 */
async function isServiceRunning(host, port) {
  return new Promise((resolve) => {
    const options = {
      hostname: host,
      port: port,
      path: '/',
      method: 'GET',
      timeout: 2000
    };
    const req = http.request(options, res => {
      resolve(true);
    });
    req.on('error', err => {
      resolve(false);
    });
    req.on('timeout', () => {
      req.destroy();
      resolve(false);
    });
    req.end();
  });
}

// -----------------------------------------------------------------
// Dataconnect HTTP functions
// We'll assume the dataconnect emulator is on localhost:9399
// -----------------------------------------------------------------

// Example: Using the generated SDK action shortcut function to execute a query
async function dataconnectFetchMovies() {
  try {
    const { data } = await listMovies(dataConnect);
    console.log('Movies:', data.movies);
    return data;
  } catch (error) {
    console.error('Error fetching movies:', error);
    throw error;
  }
}

// Alternatively, using QueryRef and executeQuery
async function dataconnectFetchMoviesViaQueryRef() {
  try {
    const ref = listMoviesRef(dataConnect);
    const { data } = await executeQuery(ref);
    console.log('Movies via QueryRef:', data.movies);
    return data;
  } catch (error) {
    console.error('Error fetching movies via QueryRef:', error);
    throw error;
  }
}

// Example: Using the generated SDK to execute a mutation to add a movie.
async function dataconnectAddMovie(newMovie) {
  try {
    // Assume createMovieRef is a generated function that creates a mutation reference.
    // You need to ensure that such a function exists in your generated SDK.
    const ref = createMovieRef(newMovie);
    const { data } = await executeMutation(ref);
    console.log('New movie added:', data);
    return data;
  } catch (error) {
    console.error('Error adding movie:', error);
    throw error;
  }
}

// HTTP function for dataconnect_fetchMovies
export const dataconnect_httpFetchMovies = functions.https.onRequest(async (req, res) => {
  // Check if dataconnect emulator is running on port 9399
  if (!(await isServiceRunning('localhost', 9399))) {
    res.status(503).json({ error: "dataconnect service is not currently running..." });
    return;
  }
  try {
    const result = await dataconnectFetchMovies();
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.toString() });
  }
});

// HTTP function for dataconnect_fetchMoviesViaQueryRef
export const dataconnect_httpFetchMoviesViaQueryRef = functions.https.onRequest(async (req, res) => {
  if (!(await isServiceRunning('localhost', 9399))) {
    res.status(503).json({ error: "dataconnect service is not currently running..." });
    return;
  }
  try {
    const result = await dataconnectFetchMoviesViaQueryRef();
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.toString() });
  }
});

// HTTP function for dataconnect_addMovie
export const dataconnect_httpAddMovie = functions.https.onRequest(async (req, res) => {
  if (!(await isServiceRunning('localhost', 9399))) {
    res.status(503).json({ error: "dataconnect service is not currently running..." });
    return;
  }
  try {
    const newMovie = req.body;
    const result = await dataconnectAddMovie(newMovie);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.toString() });
  }
});

// -----------------------------------------------------------------
// Firestore HTTP functions
// We'll assume the Firestore emulator is running on port 8080
// -----------------------------------------------------------------

// HTTP function to add an album to Firestore
export const firestore_httpAddAlbum = functions.https.onRequest(async (req, res) => {
  // Check if Firestore emulator is running on port 8080
  if (!(await isServiceRunning('localhost', 8080))) {
    res.status(503).json({ error: "firestore service is not currently running..." });
    return;
  }
  try {
    const { name, artist } = req.body;
    if (!name || !artist) {
      res.status(400).json({ error: 'Missing album name or artist.' });
      return;
    }
    const album = { name, artist };
    const docRef = await admin.firestore().collection('albums').add(album);
    res.status(200).json({ id: docRef.id, ...album });
  } catch (error) {
    console.error('Error adding album:', error);
    res.status(500).json({ error: error.toString() });
  }
});
  
// HTTP function to list all albums from Firestore
export const firestore_httpListAlbums = functions.https.onRequest(async (req, res) => {
  if (!(await isServiceRunning('localhost', 8080))) {
    res.status(503).json({ error: "firestore service is not currently running..." });
    return;
  }
  try {
    const snapshot = await admin.firestore().collection('albums').get();
    const albums = [];
    snapshot.forEach(doc => {
      albums.push({ id: doc.id, ...doc.data() });
    });
    res.status(200).json(albums);
  } catch (error) {
    console.error('Error fetching albums:', error);
    res.status(500).json({ error: error.toString() });
  }
});