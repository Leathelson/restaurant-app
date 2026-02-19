const { initializeApp } = require("firebase/app");
const { getFirestore, doc, setDoc } = require("firebase/firestore"); 


const {
  FIREBASE_apiKey,
  FIREBASE_authDomain,
  FIREBASE_projectId,
  FIREBASE_storageBucket,
  FIREBASE_messagingSenderId,
  FIREBASE_appId,
  FIREBASE_measurementId,
} = process.env;

const firebaseConfig = {
  apiKey: FIREBASE_apiKey,
  authDomain: FIREBASE_authDomain,
  projectId: FIREBASE_projectId,
  storageBucket: FIREBASE_storageBucket,
  messagingSenderId: FIREBASE_messagingSenderId,
  appId: FIREBASE_appId,
  measurementId: FIREBASE_measurementId,
};

let app;
let firestoreDb;

const initializeFirebase = () => {
  if (!app) {
    app = initializeApp(firebaseConfig);
    firestoreDb = getFirestore();
    console.log("Firebase initialized");
    return app;
  }else{
    console.log("Firebase already initialized or Something went wrong");
  }
};

const uploadProcessData = async () => {
  const dataToUpload = {
    date_registry: new Date().toISOString(),
    email: "testess12@gmail.com",
    name: "Johnathan",
    password: "hashed_password_example",
    phone: "1234567890"
  };
  try {
    const document = doc(firestoreDb, "Testing", "kENuzurV6MIjerGTNCq6" );
    let dataUpdated = await setDoc(document, dataToUpload);
    console.log("Document successfully written!", dataUpdated);
    return dataUpdated;
  } catch (error) {
    console.error("Error writing document: ", error);
  }
};


const getFirebaseApp = () => app;

module.exports = { initializeFirebase, getFirebaseApp, uploadProcessData };