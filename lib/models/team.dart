/// Class: Team
///
/// Idea: To organize info about a team on the client side for organization.
///       globals.dart should store the current team the user is accessing.

class Team {
  String name = '';
  int teamID = 0;

  Team(this.name, this.teamID);

  Team.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    teamID = json['teamID'];
  }
}
