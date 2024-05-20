import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Create a new user account
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a user document in Firestore
      await _createUserDocument(userCredential.user!.uid, email);

      return userCredential.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Create a user document in Firestore
  Future<void> _createUserDocument(String userId, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        // Additional fields can be added as needed
      });
    } catch (e) {
      print("Error creating user document: $e");
    }
  }

  // Retrieve user document from Firestore
  Future<DocumentSnapshot?> getUserDocument(String userId) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    } catch (e) {
      print("Error getting user document: $e");
      return null;
    }
  }

  // Update user document in Firestore
  Future<void> updateUserDocument(
      String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(data);
    } catch (e) {
      print("Error updating user document: $e");
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Retrieve user document upon login
      DocumentSnapshot? userDoc =
          await getUserDocument(userCredential.user!.uid);
      if (userDoc != null) {
        // Handle user document data
        print("User email: ${userDoc.data()}");
      }

      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<String> fetchUsernameFromFirestore(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('username')) {
        return userData['username'] ?? '';
      }
    }
    return ''; // Return an empty string if the username is not found or null
  }

  Future<List<DateTime>> fetchTimesDataFromFirestore(String uid) async {
    List<DateTime> sleepTimes = [];

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('sleepTimes')) {
        List<dynamic>? sleepTimesData = userData['sleepTimes'];

        if (sleepTimesData != null) {
          sleepTimesData.forEach((timestamp) {
            sleepTimes.add((timestamp as Timestamp).toDate());
          });
        }
      }
    }

    return sleepTimes;
  }

  Future<dynamic> fetchUserDataFromFirestore(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        return userSnapshot.data();
      } else {
        // Handle case where user data does not exist
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the database operation
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> addSleepTime(
      String userId, DateTime bedtime, DateTime wakeupTime) async {
    try {
      // Get a reference to the users collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Check if the user document exists
      DocumentSnapshot userDoc = await users.doc(userId).get();
      if (!userDoc.exists) {
        // If the document doesn't exist, create it
        await users.doc(userId).set({});
      }

      // Add sleep time to Firestore
      await users.doc(userId).update({
        'sleepTime': FieldValue.arrayUnion([
          {
            'bedtime': bedtime,
            'wakeupTime': wakeupTime,
          }
        ])
      });
    } catch (e) {
      print('Error adding sleep time: $e');
      throw e; // Re-throw the error to handle it in the UI
    }
  }
}
