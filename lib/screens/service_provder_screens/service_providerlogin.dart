/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/admin_screens/admin_home.dart';
import 'package:flutter_application_1/screens/catering_screen.dart';
import 'package:flutter_application_1/screens/organizing_team_screen.dart';
import 'package:flutter_application_1/screens/photographers_screens/photographer_screen.dart';
import 'package:flutter_application_1/screens/venues_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProviderLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save user login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userCredential.user!.uid);

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Navigate based on role
        switch (role) {
          case 'photographer':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PhotographersScreen()));
            break;
          case 'catering':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CateringScreen()));
            break;
          case 'venue_owner':
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => VenuesScreen()));
            break;
          case 'organizing_team':
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OrganizingTeamScreen()));
            break;
          case 'admin':
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AdminHome()));
            break;
          default:
            // Handle unknown role
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unknown role: $role')),
            );
        }
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Service Provider / Admin Login")),
      backgroundColor: const Color.fromARGB(255, 253, 171, 168),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () => login(context),
            ),
          ],
        ),
      ),
    );
  }
}*/
