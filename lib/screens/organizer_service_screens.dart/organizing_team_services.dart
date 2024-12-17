import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrganizingTeamServices extends StatefulWidget {
  @override
  _OrganizingTeamServicesState createState() => _OrganizingTeamServicesState();
}

class _OrganizingTeamServicesState extends State<OrganizingTeamServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Catering Requests'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Organizing_companies_requests')
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['company_name'] ?? 'No Company Name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Owner: ${data['owner_full_name'] ?? 'N/A'}'),
                      Text('Email: ${data['business_email'] ?? 'N/A'}'),
                      Text('Location: ${data['location'] ?? 'No Location'}'),
                      Text('Status: ${data['status'] ?? 'N/A'}'),
                      Text(
                          'Available Time: ${data['available_time'] ?? 'N/A'}'),
                      Text('Price: ${data['price'] ?? 'N/A'}'),
                      SizedBox(height: 10),
                      Text(
                        'Description:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(data['description'] ?? 'No Description'),
                      SizedBox(height: 10),
                      Text(
                        'Social Media Accounts:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (data['social_media_accounts'] != null) ...[
                        Text(
                            'Instagram: ${data['social_media_accounts']['Instagram'] ?? 'N/A'}'),
                        Text(
                            'X (Twitter): ${data['social_media_accounts']['X'] ?? 'N/A'}'),
                        Text(
                            'Facebook: ${data['social_media_accounts']['facebook'] ?? 'N/A'}'),
                      ],
                      SizedBox(height: 10),
                      Text(
                        'Terms & Conditions:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(data['terms_conditions'] ?? 'No Terms'),
                      SizedBox(height: 10),
                      if (data['images'] != null && data['images'] is List)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            data['images'].length,
                            (imageIndex) {
                              return Image.network(
                                data['images'][imageIndex],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
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
