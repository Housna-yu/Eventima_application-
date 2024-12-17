import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(AdminCateringRequestsApp());

class AdminCateringRequestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        hintColor: Colors.orangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminCateringRequests(),
    );
  }
}

class AdminCateringRequests extends StatelessWidget {
  final List<Map<String, dynamic>> requests = [
    {
      'companyName': 'Company A',
      'status': 'Pending',
      'photos': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'details': 'Details about the request from Company A.',
    },
    {
      'companyName': 'Company B',
      'status': 'Pending',
      'photos': [
        'https://via.placeholder.com/50',
        'https://via.placeholder.com/50',
        'https://via.placeholder.com/50',
        'https://via.placeholder.com/50',
      ],
      'details': 'Details about the request from Company B.',
    },
    // More requests here...
  ];

  void acceptRequest(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Request Accepted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void rejectRequest(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Request Rejected",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Catering Requests'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        // Wrapping the entire body with scroll
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // Using a Column to hold the content
            children: [
              GridView.builder(
                shrinkWrap: true, // Makes GridView respect available space
                physics:
                    NeverScrollableScrollPhysics(), // Prevents scroll inside GridView
                itemCount: requests.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.5, // Aspect ratio for each request card
                ),
                itemBuilder: (context, index) {
                  var request = requests[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        // Request Company Name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            request['companyName'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        // Photos Carousel
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: request['photos'].length,
                            itemBuilder: (context, photoIndex) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  request['photos'][photoIndex],
                                  fit: BoxFit.cover,
                                  width: 50,
                                ),
                              );
                            },
                          ),
                        ),
                        // Details of the request
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            request['details'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Buttons: Accept & Reject
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => acceptRequest(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: () => rejectRequest(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
