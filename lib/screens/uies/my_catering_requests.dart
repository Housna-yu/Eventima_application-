import 'package:flutter/material.dart';

class MycateringRequestsUI extends StatelessWidget {
  final Map<String, dynamic> user = {
    'first_name': 'Dren',
    'last_name': 'Yousif Seedahmed',
    'email': 'daren120@gmail.com',
    'company_name': 'Dora Joy',
    'image': 'assets/girl4.jpg',
    'requests': [
      {
        'account_number': '654321',
        'available_time': '1 PM - 4 PM',
        'business_email': 'info@smithcatering.com',
        'description': 'Wedding catering services.',
        'food_category': 'Main Courses',
        'location': 'Uptown',
        'price': '\$1000',
        'facebook': 'Doe Enterprises',
        'instagram': 'Doe Enterprises',
        'gender': '_',
        'X': 'Doe Enterprises',
        'status': 'accepted',
        'images': ['assets/catering1.jpg'],
      },
      {
        'account_number': '123456',
        'available_time': '2 PM - 5 PM',
        'business_email': 'contact@doeenterprises.com',
        'description': 'Catering for corporate events.',
        'food_category': 'Appetizers',
        'location': 'Cairo, Egypt',
        'price': '\$500 per dish',
        'facebook': 'Doe Enterprises',
        'instagram': 'Doe Enterprises',
        'gender': '_',
        'X': 'Doe Enterprises',
        'status': 'pending',
        'images': ['assets/catering 2.jpg'],
      },
      {
        'account_number': '123456',
        'available_time': '2 PM - 5 PM',
        'business_email': 'contact@doeenterprises.com',
        'description': 'Catering for corporate events.',
        'food_category': 'Appetizers',
        'location': 'Cairo, Egypt',
        'price': '\$900 per dish',
        'facebook': 'Doe Enterprises',
        'instagram': 'Doe Enterprises',
        'gender': '_',
        'X': 'Doe Enterprises',
        'status': 'rejecteds',
        'images': ['assets/catering 3.jpg'],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My catering Requests',
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
                          Text('Food Category: ${request['food_category']}',
                              style: TextStyle(fontSize: 16)),
                          Text('gender: ${request['gender']}',
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
