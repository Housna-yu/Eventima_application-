import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class serviceproviderhome extends StatelessWidget {
  const serviceproviderhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(
                  context, '/ftwelcom'); // Navigate to login screen
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome service provider ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
