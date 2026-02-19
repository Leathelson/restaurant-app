
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyAafLyDTiUIeF_QPUQeO4L6s2JJCUdOHVE",
  authDomain: "restotestbed.firebaseapp.com",
  projectId: "restotestbed",
  storageBucket: "restotestbed.firebasestorage.app",
  messagingSenderId: "267388970581",
  appId: "1:267388970581:web:303d436913938f94ce16dc",
  measurementId: "G-HDZEV0L4Q3"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);