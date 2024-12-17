import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_form_request.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_services_screen.dart';
import 'package:flutter_application_1/screens/organizer_service_screens.dart/organizers_request_form.dart';
import 'package:flutter_application_1/screens/organizer_service_screens.dart/organizing_team_services.dart';
import 'package:flutter_application_1/screens/profile_Screen.dart';

class OrganizingTeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizing teams Home',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/ftwelcom');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Organizing Services!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Explore our services and manage your events requests with ease.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: 3,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return _buildFeatureCard(
                    context,
                    icon: _getIconForIndex(index),
                    title: _getTitleForIndex(index),
                    description: _getDescriptionForIndex(index),
                    onTap: () => _handleNavigation(context, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple.shade800,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(context,
              icon: Icons.request_page, title: 'Request Form', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrganizingRequestForm(serviceProviderId: '')),
            );
          }),
          _buildDrawerItem(context,
              icon: Icons.design_services, title: 'Services', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrganizingTeamServices()),
            );
          }),
          _buildDrawerItem(context, icon: Icons.person, title: 'Profile',
              onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }),
          _buildDrawerItem(context,
              icon: Icons.bookmark, title: 'Booking reqests', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple.shade800),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.purple.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.purple.shade800),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.request_page;
      case 1:
        return Icons.design_services;
      case 2:
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Request Form';
      case 1:
        return 'Services';
      case 2:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  String _getDescriptionForIndex(int index) {
    switch (index) {
      case 0:
        return 'Submit your requests.';
      case 1:
        return 'Browse your services.';
      case 2:
        return 'View and edit your profile.';
      default:
        return 'Unknown';
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CateringRequestForm(serviceProviderid: '')),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CateringServices()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      default:
        break;
    }
  }
}
