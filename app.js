const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK using the service account key
const serviceAccount = require(path.resolve(__dirname, './flutter_application_1/eventima-93e43-firebase-adminsdk-49kcj-92486965d5.json'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-database-name.firebaseio.com', // Replace with your database URL
});

const db = admin.firestore();
const auth = admin.auth();

// Set custom claim for a user and update Firestore role
const setAdminRole = (uid) => {
  admin.auth().setCustomUserClaims(uid, { admin: true })
    .then(() => {
      console.log('Custom claim set successfully for', uid);

      // Update Firestore `users` collection to reflect the admin role
      return db.collection('users').doc(uid).update({ role: 'admin' });
    })
    .then(() => {
      console.log('Firestore role updated successfully for', uid);
    })
    .catch((error) => {
      console.error('Error setting admin role:', error);
    });
};

// Example: Fetch user by UID
auth.getUserByEmail('admin@example.com') // Replace with actual admin email
  .then(userRecord => {
    console.log('User data:', userRecord.toJSON());
  })
  .catch(error => {
    console.error('Error fetching user data:', error);
  });
