import 'package:flutter/material.dart';
import 'package:shay_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shay_app/services/globals.dart' as globals;
import 'dart:convert';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final List<User> _users = [];

  Future fetchUsers() async {
    var response = await http.post(
      Uri.parse(globals.httpURL),
      body: json.encode(
        {
          'key': 'team_fetch',
          'teamID': globals.currentTeam.teamID,
        },
      ),
    );
    // debugPrint(response.body);

    // Parse into User objects, store into 'user' list
    var users = <User>[];

    if (response.statusCode == 200) {
      // http returns 200 means OK
      debugPrint('Fetching Tasks: http.get OK');

      var usersJson = json.decode(response.body);
      for (var userJson in usersJson) {
        users.add(User.fromJson(userJson));
      }
    } else {
      debugPrint('Fetching Tasks: http.get BAD');
    }

    return users;
  }

  @override
  void initState() {
    fetchUsers().then((value) {
      setState(() {
        _users.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Team Roster'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) {
              var name = _users[index].name;
              var email = _users[index].email;
              var privilege = _users[index].privilege;

              return Card(
                elevation: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          size: 35,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(email),
                            Text(privilege),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: _users.length,
          ),
        ),
      ),
    );
  }
}
