import '../models/team.dart';

class TeamService {
  List<Team> teams = [
    Team(name: "Team A", role: "Organizer"),
    Team(name: "Team B", role: "Support"),
  ];

  List<Team> getTeams() {
    return teams;
  }
}