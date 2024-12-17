import 'package:flutter/material.dart';

class MyVenuesRequestsUI extends StatelessWidget {
  final Map<String, dynamic> user = {
    'first_name': 'maya',
    'last_name': 'Amir',
    'email': 'Mayagroup120@gmail.com',
    'company_name': 'Maya Group',
    'id number': 'Id number: 1128490',
    'image': 'assets/girl1.jpg',
    'requests': [
      {
        'account_number': '654321',
        'available_time': '1 PM - 4 PM',
        'business_email': 'info@Mayagroup.com',
        'description': 'Wedding hall ',
        'capacity': '150 to 200 seats ',
        'location': 'Uptown',
        'price': '\$1000',
        'status': 'accepted',
        'venue name': 'Nights',
        'terms and conditions': '_',
        'Number of staff': '15 waiter',
        'facebook': 'Nights',
        'instagram': 'Nights',
        'X': 'Nights',
        'images': ['assets/venue1.jpg'],
      },
      {
        'account_number': '123456',
        'available_time': '2 PM - 5 PM',
        'business_email': 'contact@Mayagroup.com',
        'description': 'for small corporate events.',
        'capacity': '100 seats or less',
        'location': 'Cairo, Egypt',
        'price': '\$500 per hour',
        'status': 'pending',
        'venue name': 'Lights before',
        'terms and conditions': ' cancle only within 24 hours or less',
        'Number of staff': '2 security , 2 waiters , 1 manager ',
        'facebook': 'Lights before',
        'instagram': 'Lights before',
        'X': 'Lights before',
        'images': ['assets/venue2.jpg'],
      },
      {
        'account_number': '123456',
        'available_time': '2 PM - 5 PM',
        'business_email': 'contact@Mayagroup.com',
        'description': 'small wedding events',
        'capacity': '150 seats',
        'location': 'Cairo, Egypt',
        'price': '\$900 per night',
        'status': 'rejecteds',
        'venue name': 'Moon face',
        'terms and conditions': ' cancle only within 24 hours or less',
        'Number of staff': '2 security , 2 waiters ,manager ',
        'facebook': 'Moon face',
        'instagram': 'Moon face',
        'X': 'Moon face',
        'images': ['assets/venue3.jpg', 'assets/venue3.jpg'],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My venues Requests',
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
                        style: TextStyle(fontSize: 16)),
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
                          Text('facebook: ${request['facebook']}',
                              style: TextStyle(fontSize: 16)),
                          Text('instagram: ${request['instagram']}',
                              style: TextStyle(fontSize: 16)),
                          Text('X: ${request['X']}',
                              style: TextStyle(fontSize: 16)),
                          Text('venue name: ${request['venue name']}',
                              style: TextStyle(fontSize: 16)),
                          Text(
                              'terms and conditions: ${request['terms and conditions']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Number of staff: ${request['Number of staff']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Business Email: ${request['business_email']}',
                              style: TextStyle(fontSize: 16)),
                          Text('Description: ${request['description']}',
                              style: TextStyle(fontSize: 16)),
                          Text('capacity: ${request['capacity']}',
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
