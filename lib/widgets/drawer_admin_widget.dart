import 'package:flutter/material.dart';

class DraweradminWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("Manage Users"),
            onTap: () {
              Navigator.pushNamed(context, '/user_management');
            },
          ),
          ListTile(
            title: Text("Manage Venues"),
            onTap: () {
              Navigator.pushNamed(context, '/venue_management');
            },
          ),
          ListTile(
            title: Text("Manage Teams"),
            onTap: () {
              Navigator.pushNamed(context, '/team_management');
            },
          ),
          ListTile(
            title: Text("Manage Photographers"),
            onTap: () {
              Navigator.pushNamed(context, '/photographer_management');
            },
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}