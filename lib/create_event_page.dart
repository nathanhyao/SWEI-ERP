import 'package:flutter/material.dart';
import 'package:shay_app/models/user.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  bool switchState = false;

  List<String> users = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  String? selectedUser = 'Item 1';

  // Start date and time
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();

  // End date and time
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();

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

    // Parse into User objects, store into 'user' list
    var users = <String>[];
    if (response.statusCode == 200) {
      // http returns 200 means OK
      debugPrint('Fetching events: http.get OK');
      var usersJson = json.decode(response.body);
      for (var userJson in usersJson) {
        users.add(User.fromJson(userJson).name);
      }
    } else {
      debugPrint('Fetching events: http.get BAD');
    }
    return users;
  }

  @override
  void initState() {
    fetchUsers().then((value) {
      setState(() {
        users.clear();
        users.addAll(value);
        selectedUser = users[0];
      });
    });
    super.initState();
  }

  void _showStartDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        if (value != null) {
          _startDate = value;
        }
      });
    });
  }

  void _showStartTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _startTime,
    ).then((value) {
      setState(() {
        if (value != null) {
          _startTime = value;
        }
      });
    });
  }

  void _showEndDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        if (value != null) {
          _endDate = value;
        }
      });
    });
  }

  void _showEndTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _endTime,
    ).then((value) {
      setState(() {
        if (value != null) {
          _endTime = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: ListView(
          children: <Widget>[
            const Text(
              'Create New Event',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Text(
                  'Event is Time Off',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: switchState,
                  onChanged: (bool s) {
                    setState(() {
                      switchState = s;
                    });
                  },
                ),
              ],
            ),
            const Text(
              'Events are shifts by default',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 15),
            // Start Time
            const Text(
              'Select Start Time',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                // Choose Date
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: _showStartDatePicker,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Choose Time
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: _showStartTimePicker,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Time',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // End Time
            const Text(
              'Select End Time',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                // Choose Date
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: _showEndDatePicker,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Choose Time
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: _showEndTimePicker,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Time',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // End Time
            const Text(
              'Assign Member',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedUser,
              items: users
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (item) => setState(() {
                selectedUser = item;
              }),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate back to event page. Don't save (cancel)
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      // Parse start and end date/times into correct format
                      // Format: yyyy-MM-dd HH:mm

                      // Prepare start time string
                      DateTime startDateTime = DateTime(
                        _startDate.year,
                        _startDate.month,
                        _startDate.day,
                        _startTime.hour,
                        _startTime.minute,
                      );
                      String start =
                          DateFormat('yyyy-MM-dd HH:mm').format(startDateTime);
                      debugPrint(start);

                      // Prepare end time string
                      DateTime endDateTime = DateTime(
                        _endDate.year,
                        _endDate.month,
                        _endDate.day,
                        _endTime.hour,
                        _endTime.minute,
                      );
                      String end =
                          DateFormat('yyyy-MM-dd HH:mm').format(endDateTime);
                      debugPrint(end);

                      http.Response response;
                      try {
                        response = await http.post(
                          Uri.parse(globals.httpURL),
                          body: json.encode(
                            {
                              'key': 'event_create',
                              'teamID': globals.currentTeam.teamID,
                              'start': start,
                              'end': end,
                              'name': selectedUser,
                              'is_time_off': switchState,
                            },
                          ),
                        );
                      } catch (e) {
                        globals.showSnackBar(
                            context, 'Network Communication Error');
                        return;
                      }

                      if (response.statusCode == 200) {
                        debugPrint('Creating event: http.post OK');
                        debugPrint('response.body = ${response.body}');

                        // ignore: use_build_context_synchronously
                        globals.showSnackBar(context, 'Event Created');

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(); // Back to events page

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(); // Back to home screen

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed('/home/calendar');
                      } else {
                        debugPrint('Creating event: http.post BAD');

                        // ignore: use_build_context_synchronously
                        globals.showSnackBar(
                            context, 'Server Communication Error');
                      }
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
