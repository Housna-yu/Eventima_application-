import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/auth_service.dart';
import 'package:flutter_application_1/screens/photographers_services_screens/photographer_screen.dart';
import 'package:flutter_application_1/screens/service_provder_screens/serviceproviderhome.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_screen.dart';
import 'package:flutter_application_1/screens/organizer_service_screens.dart/organizing_team_screen.dart';
import 'package:flutter_application_1/screens/venues_services/venues_screen.dart';

class ServiceProviderSignupScreen extends StatefulWidget {
  @override
  _ServiceProviderSignupScreenState createState() =>
      _ServiceProviderSignupScreenState();
}

class _ServiceProviderSignupScreenState
    extends State<ServiceProviderSignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  String? selectedService;
  final List<String> services = [
    'Photography Company',
    'Venue Owner',
    'Organizing Events Company',
    'Catering Company'
  ];

  Future<void> signup(BuildContext context) async {
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    // Ensure a service type is selected
    if (selectedService == null || selectedService!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a service type")),
      );
      return;
    }

    // Proceed with signup
    User? user = await _authService.signUpServiceProvider(
      firstNameController.text,
      lastNameController.text,
      organizationNameController.text,
      emailController.text,
      passwordController.text,
      selectedService!,
    );

    if (user != null) {
      print("Signup successful");
      // Navigate to the appropriate home page based on the service
      switch (selectedService) {
        case 'Photography Company':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PhotographersScreen()));
          break;
        case 'Venue Owner':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => VenuesScreen()));
          break;
        case 'Organizing Events Company':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OrganizingTeamScreen()));
          break;
        case 'Catering Company':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CateringScreen()));
          break;
        default:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => serviceproviderhome()));
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Provider Signup"),
        backgroundColor: Colors.purple.shade800,
        elevation: 0,
      ),
      backgroundColor: Colors.purple.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo or App Title
              Center(
                child: Image.asset(
                  'assets/image.png', // Replace with your logo asset
                  height: 100,
                ),
              ),
              SizedBox(height: 20),

              // First Name Input
              _buildTextField("First Name", firstNameController),

              // Last Name Input
              _buildTextField("Last Name", lastNameController),

              // Organization Name Input
              _buildTextField("Organization Name", organizationNameController),

              // Email Input
              _buildTextField("Email", emailController),

              // Password Input
              _buildTextField("Password", passwordController,
                  obscureText: true),

              // Confirm Password Input
              _buildTextField("Confirm Password", confirmPasswordController,
                  obscureText: true),

              // Service Type Dropdown
              _buildDropdown("Select Service Type", services),

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

  // Helper function to build the dropdown
  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedService,
        hint: Text("Select Service Type"),
        onChanged: (String? newValue) {
          setState(() {
            selectedService = newValue;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
      ),
    );
  }
}
