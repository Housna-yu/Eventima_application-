import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> addAdmin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill out all fields.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Save the current user information
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Create a new admin account
      UserCredential adminCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save admin details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(adminCredential.user?.uid)
          .set({
        'email': email,
        'role': 'admin',
        'firstName': firstName,
        'lastName': lastName,
      });

      // Sign out the newly created admin
      await FirebaseAuth.instance.signOut();

      // Re-sign in the original admin
      if (currentUser != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: currentUser.email!,
          password:
              'your-admin-password', // Replace with a secure method to get the original admin password.
        );
      }

      setState(() {
        _isLoading = false;
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Admin added successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${error.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Admin'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_firstNameController, 'First Name', Icons.person),
              SizedBox(height: 16),
              _buildTextField(
                  _lastNameController, 'Last Name', Icons.person_outline),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', Icons.email),
              SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', Icons.lock,
                  isPassword: true),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      addAdmin();
                    }
                  },
                  child: Text('Add Admin'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
