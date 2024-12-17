import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhotographersServices extends StatefulWidget {
  @override
  _PhotographersServicesState createState() => _PhotographersServicesState();
}

class _PhotographersServicesState extends State<PhotographersServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Photographer Requests'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('photographers_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found.'));
          }
          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final data = request.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(data['company_name'] ?? 'No Company Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Owner: ${data['owner_full_name'] ?? 'N/A'}'),
                      Text('Email: ${data['business_email'] ?? 'N/A'}'),
                      Text(
                          'Contact Number: ${data['contact_number'] ?? 'N/A'}'),
                      Text('Status: ${data['status'] ?? 'N/A'}'),
                      Text(
                          'Account Number: ${data['account_number'] ?? 'N/A'}'),
                      Text(
                          'Available Time: ${data['available_time'] ?? 'N/A'}'),
                      Text('Location: ${data['location'] ?? 'N/A'}'),
                      Text(
                          'Description: ${data['description'] ?? 'No Description'}'),
                      Text('Price: ${data['price'] ?? 'N/A'}'),
                      Text(
                          'Number of Staff: ${data['number_of_staff'] ?? 'N/A'}'),
                      Text('License: ${data['license'] ?? 'N/A'}'),
                      Text(
                          'Terms & Conditions: ${data['terms_conditions'] ?? 'N/A'}'),
                      // Gender Display
                      Text('Gender: ${data['gender']?.toString() ?? 'N/A'}'),
                      if (data['social_media_accounts'] != null) ...[
                        Text(
                            'Instagram: ${data['social_media_accounts']['Instagram'] ?? 'N/A'}'),
                        Text(
                            'Facebook: ${data['social_media_accounts']['facebook'] ?? 'N/A'}'),
                      ],
                      // Display images if available
                      if (data['images'] != null && data['images'] is List)
                        Column(
                          children: List.generate(data['images'].length,
                              (imageIndex) {
                            return Image.network(data['images'][imageIndex]);
                          }),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
