import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/drawer_admin_widget.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: DraweradminWidget(),
      body: Center(child: Text("admin")),
    );
  }
}
