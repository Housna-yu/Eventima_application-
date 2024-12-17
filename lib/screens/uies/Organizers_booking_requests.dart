import 'package:flutter/material.dart';

class OrganizersBookingRequestsUI extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {
      'first_name': ' Name: Daren',
      'last_name': 'yousif',
      'email': 'daren120@gmail.com',
      'image': 'assets/girl2.jpg',
      'requests': [
        {
          'Date/time': '2 PM - 5 PM',
          'email': 'contact@DoraJoy.com',
          'Phone number': '0865446',
          'location': 'Ciro,Egypt',
          'status': 'rejected',
          'Gender/number of organizers': '3 females',
          'More Details': 'its home event', // Gender is not provided
        },
      ],
    },
    {
      'first_name': ' Name: amira',
      'last_name': 'ahmed',
      'email': 'amira120@gmail.com',
      'image': 'assets/girl5.jpg',
      'requests': [
        {
          'Date/time': '6 PM - 10 PM',
          'email': 'amira120@gmail.com',
          'Phone number': '011865446',
          'location': 'ciro/egypt/elharam',
          'status': 'Accepted',
          'Gender/number of organizers': '16 males',
          'More Details':
              'wedding event in Moon nights hall', // Gender is not provided
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizers booking requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        Text('Phone number: ${request['Phone number']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Date/Time: ${request['Date/time']}',
                            style: TextStyle(fontSize: 16)),
                        Text(' Email: ${request['email']}',
                            style: TextStyle(fontSize: 16)),
                        Text(
                            'Gender/number of organizers: ${request['Gender/number of organizers']}',
                            style: TextStyle(fontSize: 16)),
                        Text('Location: ${request['location']}',
                            style: TextStyle(fontSize: 16)),
                        Text('More Details: ${request['More Details']}',
                            style: TextStyle(fontSize: 16)),
                        Text('Status: ${request['status']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: request['status'] == 'accepted'
                                    ? Colors.green
                                    : Colors.orange)),
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
