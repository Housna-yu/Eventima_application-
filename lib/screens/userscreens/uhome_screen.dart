import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile_Screen.dart';
import 'package:flutter_application_1/screens/userscreens/catering_booking_screen.dart';
import 'package:flutter_application_1/screens/userscreens/checkout_screen.dart';
import 'package:flutter_application_1/screens/userscreens/organizing_booking_screen.dart';
import 'package:flutter_application_1/screens/userscreens/photographers_booking_screen.dart';
import 'package:flutter_application_1/screens/userscreens/venues_booking_screen.dart';

class uHomeScreen extends StatefulWidget {
  @override
  _uHomeScreenState createState() => _uHomeScreenState();
}

class _uHomeScreenState extends State<uHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allItems = [
    'Home',
    'Venues',
    'Photographers',
    'Profile',
    'Checkout',
    'Sign Up',
  ];
  List<String> _filteredItems = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredItems = []; // Initialize with an empty list
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (query.isNotEmpty) {
          _filteredItems = _allItems
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else {
          _filteredItems = []; // Clear suggestions if the input is empty
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out
              Navigator.pushReplacementNamed(context, '/ftwelcom');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(), // Search bar at the top
            SizedBox(height: 20), // Space between search bar and buttons
            _buildSuggestionList(), // Show suggestions below search bar
            _buildCircularButtons(
                context), // Circular buttons below suggestions
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(width: 1.0, color: Colors.deepPurple),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSuggestionList() {
    return _filteredItems.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.search, color: Colors.deepPurple),
                title: Text(_filteredItems[index]),
                onTap: () {
                  _navigateToScreen(_filteredItems[index]);
                },
              );
            },
          )
        : Container(); // Empty container if no suggestions
  }

  void _navigateToScreen(String item) {
    switch (item) {
      case 'Home':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => uHomeScreen()));
        break;
      case 'Venues':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => venuesbookingscreen()));
        break;
      case 'Photographers':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => photographersbookingscreen()));
        break;
      case 'Profile':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 'Checkout':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
        break;
      case 'Sign Up':
        // Navigate to SignUp screen (to be implemented)
        break;
    }
  }

  Widget _buildCircularButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularIcon(context, 0),
            SizedBox(width: 16.0),
            _buildCircularIcon(context, 1),
            SizedBox(width: 16.0),
            _buildCircularIcon(context, 2),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularIcon(context, 3),
            SizedBox(width: 16.0),
            _buildCircularIcon(context, 4),
            SizedBox(width: 16.0),
            _buildCircularIcon(context, 5),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularIcon(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _navigateToScreen(_getIconNameForIndex(index));
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.deepPurple,
        child: Icon(
          _getIconForIndex(index),
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.event;
      case 2:
        return Icons.photo;
      case 3:
        return Icons.person;
      case 4:
        return Icons.shopping_cart;
      case 5:
        return Icons.settings;
      default:
        return Icons.help;
    }
  }

  String _getIconNameForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Venues';
      case 2:
        return 'Photographers';
      case 3:
        return 'Profile';
      case 4:
        return 'Checkout';
      case 5:
        return 'Sign Up';
      default:
        return '';
    }
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.deepPurple),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => uHomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.deepPurple),
            title: Text('Venues'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => venuesbookingscreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.photo, color: Colors.deepPurple),
            title: Text('Photographers'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => photographersbookingscreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.deepPurple),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.food_bank, color: Colors.deepPurple),
            title: Text('Catering companies'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CateringBookingPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.deepPurple),
            title: Text('Organizingteams'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => organizersbookingscreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.deepPurple),
            title: Text('Checkout'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
