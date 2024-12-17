import 'package:flutter/material.dart';

class PhotographerProfileScreen extends StatelessWidget {
  final String name;
  final String email;

  PhotographerProfileScreen({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement change password logic
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
