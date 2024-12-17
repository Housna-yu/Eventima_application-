import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?;
        setState(() {
          profileImageUrl =
              data?['profileImage'] ?? 'assets/default_avatar.jpeg';
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String filePath = 'profile_pictures/${_auth.currentUser!.uid}.jpeg';
      File imageFile = File(pickedFile.path);

      await _storage.ref(filePath).putFile(imageFile);
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'profileImage': downloadUrl,
      });

      setState(() {
        profileImageUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: Text("No user logged in."))
          : FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text("User data not found."));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _uploadImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.deepPurple,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: profileImageUrl != null
                                    ? NetworkImage(profileImageUrl!)
                                    : AssetImage('assets/default_avatar.jpeg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildProfileInfoCard(
                          title: "First Name",
                          value: userData['firstName'] ?? 'N/A',
                          icon: Icons.person,
                        ),
                        _buildProfileInfoCard(
                          title: "Last Name",
                          value: userData['lastName'] ?? 'N/A',
                          icon: Icons.person_outline,
                        ),
                        _buildProfileInfoCard(
                          title: "Email",
                          value: userData['email'] ?? 'N/A',
                          icon: Icons.email,
                        ),
                        _buildProfileInfoCard(
                          title: "Role",
                          value: userData['role'] ?? 'N/A',
                          icon: Icons.work,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileInfoCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              fontSize: 14, color: const Color.fromARGB(255, 57, 37, 10)),
        ),
      ),
    );
  }
}
