import 'package:flutter/material.dart';
import '../models/team.dart';

class TeamProvider with ChangeNotifier {
  final List<Team> _teams = [];

  List<Team> get teams => _teams;

  void addTeam(Team team) {
    _teams.add(team);
    notifyListeners();
  }

  void editTeam(int index, Team team) {
    _teams[index] = team;
    notifyListeners();
  }

  void deleteTeam(int index) {
    _teams.removeAt(index);
    notifyListeners();
  }
}