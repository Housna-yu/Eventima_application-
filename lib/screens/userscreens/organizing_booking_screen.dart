import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class organizersbookingscreen extends StatelessWidget {
  const organizersbookingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("organizers booking page"),
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
    ));
  }
}
