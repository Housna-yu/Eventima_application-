import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRegistrationPage extends StatefulWidget {
  @override
  _AdminRegistrationPageState createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Function to handle admin registration
  Future<void> registerAdmin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create admin user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save admin details in Firestore
        String adminId = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(adminId).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'admin',
        });

        if (mounted) {
          ScaffoldMessenger.of(Scaffold.of(context).context).showSnackBar(
            SnackBar(content: Text('Admin registered successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Registration'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'First name is required' : null,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Last name is required' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: registerAdmin,
                        child: Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
