import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Menu",
                style: TextStyle(color: Colors.white, fontSize: 24)),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text("Profile"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: Text("Venues"),
            onTap: () {
              Navigator.pushNamed(context, '/venues');
            },
          ),
          ListTile(
            title: Text("Organizing Team"),
            onTap: () {
              Navigator.pushNamed(context, '/organizing_team');
            },
          ),
          ListTile(
            title: Text("Photographers"),
            onTap: () {
              Navigator.pushNamed(context, '/photographer');
            },
          ),
          ListTile(
            title: Text("admin"),
            onTap: () {
              Navigator.pushNamed(context, '/admin_panel');
            },
          ),
        ],
      ),
    );
  }
}
