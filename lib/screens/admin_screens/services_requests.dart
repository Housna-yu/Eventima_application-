import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> checkUserClaims() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Check if the user is an admin
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((snapshot) {
      String role = snapshot.data()?['role'] ?? '';
      if (role == 'admin') {
        // The user is an admin, proceed with the operation
        print('Admin access granted');
      } else {
        // Handle non-admin case
        print('Non-admin access');
      }
    }).catchError((e) {
      print('Error fetching user role: $e');
    });
  }
}

Future<bool> isAdmin() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims?['admin'] == true;
    } catch (e) {
      print('Error fetching admin claims: $e');
      return false;
    }
  }
  return false;
}

Stream<QuerySnapshot> getCateringRequestsStream(String serviceProviderId) {
  return FirebaseFirestore.instance
      .collection('users') // users collection
      .doc(serviceProviderId) // specific service provider document ID
      .collection('catering_requests') // catering_requests sub-collection
      .snapshots();
}

Future<void> updateRequestStatus(
    String serviceProviderId, String requestId, String status) async {
  try {
    await FirebaseFirestore.instance
        .collection('users') // users collection
        .doc(serviceProviderId) // service provider document ID
        .collection('catering_requests') // catering_requests sub-collection
        .doc(requestId) // specific request ID
        .update({'status': status}) // update the status (passed as parameter)
        .then((_) {
      print('Request status updated to $status');
    });
  } catch (e) {
    print('Error updating status: $e');
  }
}

class CateringServicesRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catering Requests'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Stream snapshot error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream: getCateringRequestsStream(userId),
                builder: (context, cateringSnapshot) {
                  if (cateringSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (cateringSnapshot.hasError) {
                    print("Catering snapshot error: ${cateringSnapshot.error}");
                    return Center(
                        child: Text('Error: ${cateringSnapshot.error}'));
                  }

                  final requests = cateringSnapshot.data!.docs;

                  // Only display user information once
                  return ExpansionTile(
                    backgroundColor: Colors.deepPurple[50],
                    textColor: Colors.deepPurple,
                    iconColor: Colors.deepPurple,
                    title: Text(
                      userDoc['company_name'] ?? 'No Company Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Owner: ${userDoc['owner_full_name'] ?? 'Unknown'}',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    children: requests.map((request) {
                      final requestData =
                          request.data() as Map<String, dynamic>;

                      return Card(
                        color: Colors.deepPurple[100],
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Request ID: ${request.id}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'Account Number: ${requestData['account_number'] ?? 'N/A'}'),
                              Text(
                                  'Available Time: ${requestData['available_time'] ?? 'N/A'}'),
                              Text(
                                  'Business Email: ${requestData['business_email'] ?? 'N/A'}'),
                              Text(
                                  'Description: ${requestData['description'] ?? 'N/A'}'),
                              Text(
                                  'Food Category: ${requestData['food_category'] ?? 'N/A'}'),
                              Text(
                                  'Location: ${requestData['location'] ?? 'N/A'}'),
                              Text('Price: ${requestData['price'] ?? 'N/A'}'),
                              Text('Status: ${requestData['status'] ?? 'N/A'}'),
                              Text(
                                  'Terms & Conditions: ${requestData['terms_conditions'] ?? 'N/A'}'),
                              if (requestData['images'] != null &&
                                  requestData['images'] is List)
                                ...List.generate(
                                  requestData['images'].length,
                                  (imageIndex) => Image.network(
                                    requestData['images'][imageIndex],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (requestData['social_media_account'] != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Instagram: ${requestData['social_media_account']['Instagram'] ?? 'N/A'}'),
                                    Text(
                                        'Facebook: ${requestData['social_media_account']['facebook'] ?? 'N/A'}'),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'accepted');
                                      },
                                    ),
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon:
                                          Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'rejected');
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PhotographersRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photographers Requests'),
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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream: getPhotographersRequestsStream(userId),
                builder: (context, requestSnapshot) {
                  if (requestSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (requestSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${requestSnapshot.error}'));
                  }

                  final requests = requestSnapshot.data!.docs;

                  if (requests.isEmpty) {
                    return SizedBox(); // No requests for this user
                  }

                  return ExpansionTile(
                    backgroundColor: Colors.deepPurple[50],
                    textColor: Colors.deepPurple,
                    iconColor: Colors.deepPurple,
                    title: Text(
                      userDoc['company_name'] ?? 'No Company Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Owner: ${userDoc['owner_full_name'] ?? 'Unknown'}',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    children: requests.map((request) {
                      final requestData =
                          request.data() as Map<String, dynamic>;

                      // Check if requestData has any relevant data
                      if (requestData.isEmpty)
                        return SizedBox(); // Skip empty requests

                      return Card(
                        color: Colors.deepPurple[100],
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Request ID: ${request.id}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'Account Number: ${requestData['account_number'] ?? 'N/A'}'),
                              Text(
                                  'Available Time: ${requestData['available_time'] ?? 'N/A'}'),
                              Text(
                                  'Business Email: ${requestData['business_email'] ?? 'N/A'}'),
                              Text(
                                  'Description: ${requestData['description'] ?? 'N/A'}'),
                              Text(
                                  'Location: ${requestData['location'] ?? 'N/A'}'),
                              Text('Price: ${requestData['price'] ?? 'N/A'}'),
                              Text(
                                  'Contact: ${requestData['contact_number'] ?? 'N/A'}'),
                              Text('Status: ${requestData['status'] ?? 'N/A'}'),
                              Text(
                                  'Terms & Conditions: ${requestData['terms_conditions'] ?? 'N/A'}'),
                              Text(
                                  'Gender: ${requestData['gender']?.toString() ?? 'N/A'}'),
                              Text(
                                  'Number of Staff: ${requestData['number_of_staff'] ?? 'N/A'}'),

                              // Display images if available
                              if (requestData['images'] != null &&
                                  requestData['images'] is List)
                                ...requestData['images'].map((image) {
                                  return Image.network(image,
                                      fit: BoxFit.cover);
                                }).toList(),

                              // Social media accounts
                              if (requestData['social_media_accounts'] != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Instagram: ${requestData['social_media_accounts']['Instagram'] ?? 'N/A'}'),
                                    Text(
                                        'Facebook: ${requestData['social_media_accounts']['facebook'] ?? 'N/A'}'),
                                  ],
                                ),

                              // Status update buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'accepted');
                                      },
                                    ),
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon:
                                          Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'rejected');
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getPhotographersRequestsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(
            'photographers_requests') // Make sure this is the correct sub-collection name
        .snapshots();
  }

  Future<void> updateRequestStatus(
      String userId, String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('photographers_requests')
        .doc(requestId)
        .update({'status': status});
  }
}

class VenuesRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venues Requests'),
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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream: getVenuesRequestsStream(userId),
                builder: (context, requestSnapshot) {
                  if (requestSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (requestSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${requestSnapshot.error}'));
                  }

                  final requests = requestSnapshot.data!.docs;

                  return ExpansionTile(
                    backgroundColor: Colors.deepPurple[50],
                    textColor: Colors.deepPurple,
                    iconColor: Colors.deepPurple,
                    title: Text(
                      userDoc['venue_name'] ?? 'No Venue Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Owner: ${userDoc['owner_full_name'] ?? 'Unknown'}',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    children: requests.map((request) {
                      final requestData =
                          request.data() as Map<String, dynamic>;

                      return Card(
                        color: Colors.deepPurple[100],
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Request ID: ${request.id}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'Account Number: ${requestData['account_number'] ?? 'N/A'}'),
                              Text(
                                  'Available Time: ${requestData['available_time'] ?? 'N/A'}'),
                              Text(
                                  'Business Email: ${requestData['business_email'] ?? 'N/A'}'),
                              Text(
                                  'Venue Name: ${requestData['venue_name'] ?? 'N/A'}'),
                              Text(
                                  'Description: ${requestData['description'] ?? 'N/A'}'),
                              Text(
                                  'Location: ${requestData['location'] ?? 'N/A'}'),
                              Text('Price: ${requestData['price'] ?? 'N/A'}'),
                              Text(
                                  'Contact: ${requestData['contact_number'] ?? 'N/A'}'),
                              Text('Status: ${requestData['status'] ?? 'N/A'}'),
                              Text(
                                  'Terms & Conditions: ${requestData['terms_conditions'] ?? 'N/A'}'),
                              Text(
                                  'Gender: ${requestData['gender']?['male'] == true ? 'Male' : requestData['gender']?['female'] == true ? 'Female' : 'Both'}'),
                              Text(
                                  'Number of Staff: ${requestData['number_of_staff'] ?? 'N/A'}'),
                              if (requestData['images'] != null &&
                                  requestData['images'] is List)
                                ...List.generate(
                                  requestData['images'].length,
                                  (imageIndex) => Image.network(
                                    requestData['images'][imageIndex],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (requestData['social_media_accounts'] != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Instagram: ${requestData['social_media_accounts']['Instagram'] ?? 'N/A'}'),
                                    Text(
                                        'Facebook: ${requestData['social_media_accounts']['facebook'] ?? 'N/A'}'),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'accepted');
                                      },
                                    ),
                                  if (requestData['status'] == 'pending')
                                    IconButton(
                                      icon:
                                          Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        updateRequestStatus(
                                            userId, request.id, 'rejected');
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getVenuesRequestsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('venues_requests')
        .snapshots();
  }

  void updateRequestStatus(
      String userId, String requestId, String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('venues_requests')
        .doc(requestId)
        .update({'status': status});
  }
}
