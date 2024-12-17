import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/auth_service.dart';
import 'package:flutter_application_1/screens/userscreens/uhome_screen.dart';

class USignupScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> signup(BuildContext context) async {
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    User? user = await _authService.signUpUser(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      // Navigate to the user home page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => uHomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed. Please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Signup"),
        backgroundColor: Colors.purple.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name Input
              _buildTextField("First Name", firstNameController),

              // Last Name Input
              _buildTextField("Last Name", lastNameController),

              // Email Input
              _buildTextField("Email", emailController),

              // Password Input
              _buildTextField("Password", passwordController,
                  obscureText: true),

              // Confirm Password Input
              _buildTextField("Confirm Password", confirmPasswordController,
                  obscureText: true),

              // Sign Up Button
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => signup(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.purple.shade800),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple.shade400),
          ),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
