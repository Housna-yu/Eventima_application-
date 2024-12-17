import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/admin_screens/requests.dart';
import 'package:flutter_application_1/screens/profile_Screen.dart';
import 'add_admin.dart';
import 'services_requests.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardTile(
              context,
              title: 'Add Admin',
              icon: Icons.person_add,
              color: Colors.deepPurple,
              destination: AddAdminScreen(),
            ),
            _buildDashboardTile(
              context,
              title: 'Profile',
              icon: Icons.account_circle,
              color: Colors.orange,
              destination: ProfileScreen(),
            ),
            _buildDashboardTile(
              context,
              title: 'Photographers Requests',
              icon: Icons.camera_alt,
              color: Colors.purpleAccent,
              destination: PhotographersRequests(),
            ),
            _buildDashboardTile(
              context,
              title: 'Venues Requests',
              icon: Icons.place,
              color: Colors.deepOrangeAccent,
              destination: VenuesRequests(),
            ),
            _buildDashboardTile(
              context,
              title: 'Catering Requests',
              icon: Icons.restaurant,
              color: Colors.orangeAccent,
              destination: CateringServicesRequests(),
            ),
            _buildDashboardTile(
              context,
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.blueGrey,
              destination:
                  AccountsAdminPage(), // Placeholder for settings screen.
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
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
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Center(
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'Dashboard',
            icon: Icons.dashboard,
            destination: AdminHomePage(),
          ),
          _buildDrawerItem(
            context,
            title: 'Add Admin',
            icon: Icons.person_add,
            destination: AddAdminScreen(),
          ),
          _buildDrawerItem(
            context,
            title: 'Profile',
            icon: Icons.account_circle,
            destination: ProfileScreen(),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
