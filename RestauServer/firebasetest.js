const { initializeFirebase } = require('./fireserver');
const {uploadProcessData} = require('./firestoreUpload');

initializeFirebase();
// Call the upload function (for testing purposes)
if (path === "/test-upload") {
    uploadProcessData();
    return "Upload attempted";
}