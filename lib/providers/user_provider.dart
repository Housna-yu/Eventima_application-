import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [
    User(name: "User 1", email: "user1@example.com"),
    User(name: "User 2", email: "user2@example.com"),
  ];

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void editUser(int index, User user) {
    _users[index] = user;
    notifyListeners();
  }

  void deleteUser(int index) {
    _users.removeAt(index);
    notifyListeners();
  }
}