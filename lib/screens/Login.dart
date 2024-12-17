// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin_screens/admin_pannel.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_screen.dart';
import 'package:flutter_application_1/screens/option_screen.dart';
import 'package:flutter_application_1/screens/organizer_service_screens.dart/organizing_team_screen.dart';
import 'package:flutter_application_1/screens/photographers_services_screens/photographer_screen.dart';
import 'package:flutter_application_1/screens/userscreens/uhome_screen.dart';
import 'package:flutter_application_1/screens/venues_services/venues_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar('Email and password cannot be empty');
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user == null) {
        _showSnackBar('User not found after login');
        return;
      }

      // Fetch user document based on the user ID
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!mounted) return; // Prevent actions if widget is not active

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data();

        if (userData == null) {
          _showSnackBar('User data not found');
          return;
        }

        String role = userData['role'] as String;
        Map<String, dynamic>? services =
            userData['services'] as Map<String, dynamic>?;
        // Check role before using it
        // ignore: unnecessary_null_comparison
        if (role == null) {
          _showSnackBar('User role is missing');
          return;
        }

        // Navigate based on the role and services
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomePage()),
          );
        } else if (role == 'service_provider') {
          if (services != null) {
            if (services['Photography Company'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PhotographersScreen()),
              );
            } else if (services['Catering Company'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CateringScreen()),
              );
            } else if (services['Venue Owner'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VenuesScreen()),
              );
            } else if (services['Organizing Events Company'] == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrganizingTeamScreen()),
              );
            } else {
              _showSnackBar('No valid service found for this provider');
            }
          } else {
            _showSnackBar('Services not set for this provider');
          }
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => uHomeScreen()),
          );
        } else {
          _showSnackBar('Unexpected role: $role');
        }
      } else {
        _showSnackBar('User document not found');
      }
    } catch (e) {
      if (!mounted) return; // Safeguard against deactivated widget
      _showSnackBar('Login failed: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    // Show the SnackBar safely
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Login to manage your events seamlessly.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade100,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                TextStyle(color: Colors.purple.shade700),
                            prefixIcon: Icon(Icons.email,
                                color: Colors.purple.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple.shade400),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                TextStyle(color: Colors.purple.shade700),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.purple.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple.shade400),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.orange.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => login(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OptionsScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
