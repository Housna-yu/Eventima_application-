import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data?.docs;

          if (users == null || users.isEmpty) {
            return Center(child: Text('No registered accounts found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                      '${userDoc['first name'] ?? ''} ${userDoc['last name'] ?? ''}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${userDoc['email'] ?? 'No Email'}'),
                      Text('Role: ${userDoc['role'] ?? 'No Role'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context, userId);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String userId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await _deleteUser(userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      // Delete user from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
