/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/service_provder_screens/service_providerpannel.dart';

class AdminHome extends StatefulWidget {
  Future<bool> isAdmin() async {
    await FirebaseAuth.instance.currentUser?.getIdToken(true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims?['admin'] == true;
    }
    return false;
  }

  Future<void> loadUserData() async {
    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((idTokenResult) {
      print("Admin claim: ${idTokenResult.claims?['admin']}");
    });
    ;

    final admin = await isAdmin();

    if (admin) {
      // Load all users' data
      FirebaseFirestore.instance.collection('users').get().then((snapshot) {
        // Process user data
      });
    } else {
      // Load only current user's data
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((snapshot) {
          // Process current user data
        });
      }
    }
  }

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CateringServices(),
    photographersrequest(),
    venuesrequests(),
    AddAdminScreen(),
    // New screen for adding an admin
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(
                  context, '/ftwelcom'); // Navigate to login screen
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 237, 186, 181),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Service Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'All Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add), // Icon for adding a new admin
            label: 'Add Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 38, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}

// Placeholder screens for navigation
class CateringServices extends StatefulWidget {
  @override
  _CateringServicesState createState() => _CateringServicesState();
}

class _CateringServicesState extends State<CateringServices> {
  // This is the user's email for filtering (you can replace with dynamic user info)
  final String userEmail = 'user_email@example.com';

  // Function to update the request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in");
        return;
      }

      // Update the status of the request in the catering_requests sub-collection
      await FirebaseFirestore.instance
          .collection('users') // Collection where user documents are stored
          .doc(user.uid) // Access the document of the logged-in user
          .collection(
              'catering_requests') // Sub-collection for catering requests
          .doc(requestId) // Specific request document ID to update
          .update({'status': status}); // Update the status field

      print("Request status updated to: $status");
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Catering Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users') // The users collection
            .doc(FirebaseAuth
                .instance.currentUser!.uid) // The logged-in user's document
            .collection(
                'catering_requests') // The sub-collection where requests are stored
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
              final requestId = request.id; // Get the document ID

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(data['companyName'] ?? 'No Company Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Owner: ${data['ownerName']}'),
                      Text('Email: ${data['email']}'),
                      Text('Status: ${data['status']}'),
                      SizedBox(height: 10),
                      Text(
                          'Description: ${data['description'] ?? 'No Description'}'),
                      Text(
                          'Location: ${data['businessLocation'] ?? 'No Location'}'),
                    ],
                  ),
                  trailing: data['status'] == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () =>
                                  updateRequestStatus(requestId, 'accepted'),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  updateRequestStatus(requestId, 'rejected'),
                            ),
                          ],
                        )
                      : null, // Hide buttons if the request is already accepted or rejected
                ),
              );
            },
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
class photographersrequest extends StatelessWidget {
  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims?['admin'] == true;
    }
    return false;
  }

  void navigateToAdminPanel(BuildContext context) async {
    final admin = await isAdmin();
    if (admin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access denied: Admins only')),
      );
    }
  }

  Stream<QuerySnapshot> getPhotographerRequests() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('photographer_requests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Accounts Page"));
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
class venuesrequests extends StatelessWidget {
  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims?['admin'] == true;
    }
    return false;
  }

  void navigateToAdminPanel(BuildContext context) async {
    final admin = await isAdmin();
    if (admin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access denied: Admins only')),
      );
    }
  }

  Stream<QuerySnapshot> getvenuesRequests() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('venues_requests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Accounts Page"));
  }
}

// New screen for adding a new admin
class AddAdminScreen extends StatefulWidget {
  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  // Function to add an admin
  Future<void> addAdmin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous errors
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please provide both email and password.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Create the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Now that the user is created, assign the admin role in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'admin': true, // Set the user as an admin
      });

      // Optional: You can send a verification email or any other logic if necessary.
      await userCredential.user?.sendEmailVerification();

      setState(() {
        _isLoading = false;
      });

      // Navigate back or show success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Admin added successfully!'),
        backgroundColor: Colors.green,
      ));

      // Optionally navigate back to the admin panel or home page
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${error.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email TextField
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password TextField
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Loading indicator
              if (_isLoading) Center(child: CircularProgressIndicator()),

              // Add Admin button
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          addAdmin();
                        }
                      },
                child: Text('Add Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
