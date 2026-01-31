const express = require('express');
const bcrypt = require('brcrypt');
const cors = require('cors');
const admin = require('firebase-admin');

const serviceAccount = require('./firebaseServiceKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const app = express();
app.use(express.json());
app.use(cors());

const PORT = 3000;

app.listen(PORT, () => {
    console.log(`FirebaseServer is running on port ${PORT}`);
});