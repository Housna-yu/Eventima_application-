import 'package:flutter/material.dart';

class WelcomeScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to Event Booking App"),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ElevatedButton(
              child: Text("Sign In"),
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
            ),
          ],
        ),
      ),
    );
  }
}
