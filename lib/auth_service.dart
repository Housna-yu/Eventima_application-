import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: public_member_api_docs
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup for regular users
  Future<User?> signUpUser(
      String firstName, String lastName, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': 'user', // Role for regular users
      });

      return userCredential.user;
    } catch (e) {
      print("User signup error: $e");
      return null;
    }
  }

  // Signup for admin users
  Future<User?> signUpAdmin(String firstName, String lastName, String email,
      String password, String confirmPassword) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store admin data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': 'admin', // Role for admin users
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.message}');
      return null; // Return null in case of an error
    } catch (e) {
      print('General error during registration: ${e.toString()}');
      return null; // Return null in case of an error
    }
  }

  // Signup for service providers with the serviceType parameter
  Future<User?> signUpServiceProvider(
    String firstName,
    String lastName,
    String organizationName,
    String email,
    String password,
    String serviceType,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Add user data to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'organizationName': organizationName,
        'email': email,
        'role': 'service_provider',
        'services': {
          serviceType: true, // Store the selected service as part of the map
        },
      });

      return user;
    } catch (e) {
      print("Sign up error: $e");
      return null;
    }
  }

  // Update service type for service provider
  Future<void> updateServiceProviderService(
      String uid, String serviceType) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'services.$serviceType':
            true, // Add or update the specific service type in the map
      });
    } catch (e) {
      print("Error updating service: $e");
    }
  }

  // Method to sign in
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Method to get user data from Firestore
  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    return snapshot.data() as Map<String, dynamic>;
  }

// In AuthService.dart
  Future<void> updateUserServiceType(
      String uid, String serviceType, dynamic userCredential) async {
    try {
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'serviceType': serviceType,
      });
    } catch (e) {
      print("Error updating service type: $e");
    }
  } // Other authentication methods (signIn, signOut, etc.) can be added here
  // Inside AuthService class

// Method to update admin service in Firestore
  Future<void> updateAdminService(String uid, String service) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'service': service, // Store the selected service
      });
    } catch (e) {
      print("Error updating admin service: $e");
    }
    // Inside AuthService class

// Method to sign in
    Future<UserCredential> signIn(String email, String password) async {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }

// Method to get user data from Firestore
    Future<Map<String, dynamic>> getUserData(String uid) async {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      return snapshot.data() as Map<String, dynamic>;
    }
  }
}
