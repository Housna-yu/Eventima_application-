import 'package:flutter/material.dart';

class MyorganizingcompanyRequestsUI extends StatelessWidget {
  final Map<String, dynamic> user = {
    'first_name': 'amin',
    'last_name': 'ahmed saif',
    'email': 'amin120@gmail.com',
    'company_name': 'amin org',
    'image': 'assets/boy3.jpg',
    'id number': 'ID number: 445468',
    'requests': [
      {
        'account_number': '654321',
        'available_time': '1 PM - 4 PM',
        'business_email': 'info@aminorg.com',
        'description': 'organizing services',
        'Number of staff': '10',
        'gender': 'males',
        'location': 'cairo,egypt',
        'price': '\$1000 per night',
        'facebook': 'amin org',
        'instagram': 'amin org',
        'X': 'amin org',
        'status': 'rejected',
        'images': [' '],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My company Requests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(user['image']),
                  radius: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user['first_name']} ${user['last_name']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('${user['company_name']}',
                        style: TextStyle(fontSize: 16)),
                    Text('${user['email']}', style: TextStyle(fontSize: 14)),
                    Text('${user['id number']}',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Requests',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Requests List
            Expanded(
              child: ListView.builder(
                itemCount: (user['requests'] as List).length,
                itemBuilder: (context, requestIndex) {
                  final request = user['requests'][requestIndex];

                  return Card(
                    margin: EdgeInsets.only(top: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Number: ${request['account_number']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Available Time: ${request['available_time']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Business Email: ${request['business_email']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Description: ${request['description']}',
                              style: TextStyle(fontSize: 16)),
                          Text('gender: ${request['gender']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Number of staff: ${request['Number of staff']}',
                              style: TextStyle(fontSize: 16)),
                          Text('facebook: ${request['facebook']}',
                              style: TextStyle(fontSize: 16)),
                          Text('instagram: ${request['instagram']}',
                              style: TextStyle(fontSize: 16)),
                          Text('X: ${request['X']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Location: ${request['location']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Price: ${request['price']}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green)),
                          Text('Status: ${request['status']}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: request['status'] == 'accepted'
                                      ? Colors.green
                                      : Colors.orange)),
                          SizedBox(height: 10),
                          if (request['images'] != null &&
                              request['images'] is List)
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: request['images'].map<Widget>((image) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
