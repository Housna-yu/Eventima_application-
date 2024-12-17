import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/service_provder_screens/servce_provider_signup_screen.dart';
import 'package:flutter_application_1/screens/userscreens/usignup_screen.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Get Started!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Choose how you'd like to sign up:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple.shade700,
                ),
              ),
              SizedBox(height: 40),

              // Service Provider Option
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceProviderSignupScreen()),
                    );
                  },
                  child: Container(
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_center,
                          size: 40,
                          color: Colors.orange.shade400,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "Sign Up as a Service Provider\n(Offer venues, photography, catering, or organizing services)",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // User Option
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => USignupScreen()),
                    );
                  },
                  child: Container(
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.orange.shade400,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "Sign Up as a User\n(Book venues, photographers, catering, or organizing services)",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
