import 'package:flutter/material.dart';

class AdminRequestsUI extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {
      'first_name': 'Dren',
      'last_name': 'yousif',
      'email': 'daren120@gmail.com',
      'role': 'service_provider',
      'Business_name': 'Dora Joy',
      'owner_full_name': 'Dren Yousif Seedahmed',
      'image': 'assets/girl4.jpg',
      'requests': [
        {
          'account_number': '123456',
          'available_time': '2 PM - 5 PM',
          'business_email': 'contact@DoraJoy.com',
          'description': 'Catering for corporate events.',
          'food_category': 'Appetizers',
          'location': 'Ciro,Egypt',
          'price range': '\$500 per dish',
          'status': 'rejected',
          'facebook': 'Dora Joy',
          'Gender': '_', // Gender is not provided
          'instagram': 'Dora Joy',
          'X': 'Dora Joy',
          'terms and conditions': 'No retern polices',
          'images': ['assets/catering1.jpg', 'assets/catering 2.jpg'],
        },
      ],
    },
    {
      'first_name': 'Jane',
      'last_name': 'Smith',
      'email': 'jane.smith@example.com',
      'role': 'user',
      'company_name': 'Smith photgraphy',
      'owner_full_name': 'Jane Smith',
      'image': 'assets/girl5.jpg',
      'requests': [
        {
          'account_number': '654321',
          'available_time': '1 PM - 4 PM',
          'business_email': 'info@smithcatering.com',
          'description': 'Wedding services.',
          'food_category': '_',
          'Gender': 'female',
          'location': 'Uptown',
          'price range': '\$1000',
          'status': 'accepted',
          'facebook': 'Smith photography',
          'instagram': 'Smith photography',
          'X': 'Smith photography',
          'terms and conditions':
              'cancle of request within 2 days, only females occuation',
          'images': [
            'assets/photograoher 1.jpg',
            'assets/photograoher 1.jpg',
            'assets/photograoher 1.jpg'
          ],
        },
      ],
    },
    {
      'first_name': 'John',
      'last_name': 'Doe Group',
      'email': 'john.doe@example.com',
      'role': 'Service provider',
      'company_name': 'Doe Enterprises',
      'owner_full_name': 'John Doe',
      'image': 'assets/boy3.jpg',
      'requests': [
        {
          'account_number': '123456',
          'available_time': '2 PM - 5 PM',
          'business_email': 'contact@doeenterprises.com',
          'description': ' weeding events organizing team.',
          'service type': 'organizing team',
          'food_category': '_',
          'location': 'Downtown',
          'price range': '\$500 per hour',
          'status': 'pending',
          'facebook': 'Doe Enterprises',
          'instagram': 'Doe Enterprises',
          'Gender': '3 males, 6 females',
          'X': 'Doe Enterprises',
          'terms and conditions': '_',
          'images': ['assets/photographer2.jpg'],
        },
      ],
    },
    {
      'first_name': 'mohamed',
      'last_name': 'emam',
      'email': 'moh.doe@example.com',
      'role': 'service provider',
      'company_name': 'ME Enterprises',
      'owner_full_name': 'mohammed ahmed al amen emam',
      'image': 'assets/boy1.jpg',
      'requests': [
        {
          'account_number': '123456',
          'available_time': '2 PM - 5 PM',
          'business_email': 'moh1@doeenterprises.com',
          'description': '150 seats capacity.',
          'location': 'Downtown',
          'price': '\$500 per hour',
          'status': 'rejected',
          'food_category': '_',
          'facebook': 'Doe Enterprises',
          'instagram': 'Doe Enterprises',
          'Gender': '3 males, 6 females',
          'X': 'Doe Enterprises',
          'terms and conditions': '_',
          'images': ['assets/venue1.jpg', 'assets/venue1.jpg'],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('requests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Card(
            margin: EdgeInsets.all(12),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user['image']),
                radius: 25,
              ),
              title: Text(
                '${user['first_name']} ${user['last_name']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Email: ${user['email']}',
                  style: TextStyle(fontSize: 14)),
              children: (user['requests'] as List).map<Widget>((request) {
                return Card(
                  margin: EdgeInsets.all(10),
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
                        Text('Food Category: ${request['food_category']}',
                            style: TextStyle(fontSize: 16)),
                        Text('facebook: ${request['facebook']}',
                            style: TextStyle(fontSize: 16)),
                        Text('instagram: ${request['instagram']}',
                            style: TextStyle(fontSize: 16)),
                        Text('X: ${request['X']}',
                            style: TextStyle(fontSize: 16)),
                        Text(
                            'terms and conditions: ${request['terms and conditions']}',
                            style: TextStyle(fontSize: 16)),
                        Text('Location: ${request['location']}',
                            style: TextStyle(fontSize: 16)),
                        Text('Gender: ${request['Gender']}',
                            style: TextStyle(fontSize: 16)),
                        Text('Price range: ${request['price range']}',
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
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showNotification(context, 'Request accepted');
                              },
                              child: Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _showNotification(context, 'Request rejected');
                              },
                              child: Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showNotification(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
