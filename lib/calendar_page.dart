import 'package:flutter/material.dart';
import 'package:shay_app/models/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
// import 'selected_day_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Calendar Properties
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final String _focusedDayStr = DateFormat.yMMMMEEEEd().format(DateTime.now());
  DateTime? _selectedDay;
  String? _selectedDayStr;

  // Events
  final List<Event> _events = [];

  // Fetch Incoming Shift Trade Events
  Future fetchEvents() async {
    http.Response response;
    try {
      debugPrint('Fetching Events');
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'event_fetch',
            'teamID': globals.currentTeam.teamID,
            'date':
                DateFormat('yyyy-MM-dd').format(_selectedDay ?? _focusedDay),
          },
        ),
      );
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }
    var events = <Event>[];
    if (response.statusCode == 200) {
      debugPrint('Fetching Events: http.get OK');
      var eventsJson = json.decode(response.body);
      // Add all relevant objects to the list
      for (var eventJson in eventsJson) {
        events.add(Event.fromJson(eventJson));
      }
    } else {
      debugPrint('Fetching Events: http.get BAD');
    }
    return events;
  }

  @override
  void initState() {
    // Fetch user's incoming Events
    fetchEvents().then((value) {
      setState(() {
        _events.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Team Calendar'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.refresh),
              onTap: () {
                setState(() {
                  // When page is refreshed, re-retrieve events
                  fetchEvents().then((value) {
                    setState(() {
                      _events.clear();
                      _events.addAll(value);
                    });
                  });
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pushNamed('/home/task/create');
          Navigator.of(context).pushNamed('/home/calendar/create');
        },
        tooltip: 'Create New Event',
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            child: TableCalendar(
              headerStyle: HeaderStyle(
                decoration: const BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  color: Colors.redAccent,
                ),
                headerMargin: const EdgeInsets.only(bottom: 8.0),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedDayStr = DateFormat.yMMMMEEEEd()
                        .format(_selectedDay ?? _focusedDay);
                    debugPrint(_selectedDayStr);

                    // If new day is selected, fetch events again
                    fetchEvents().then((value) {
                      setState(() {
                        _events.clear();
                        _events.addAll(value);
                      });
                    });
                  });
                }
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: ((context) =>
                //         SelectedDay(day: _selectedDayStr ?? _focusedDayStr)),
                //   ),
                // );
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _selectedDayStr ?? _focusedDayStr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var timeStart = _events[index].timeStart;
                var timeEnd = _events[index].timeEnd;
                var isShift = _events[index].isShift;
                var isTimeOff = _events[index].isTimeOff;
                var assignedName = _events[index].assignedName;
                var assignedEmail = _events[index].assignedEmail;

                return Card(
                  margin: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 4.0,
                    bottom: 4.0,
                  ),
                  elevation: 2.5,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.assignment_outlined,
                            size: 35,
                          ),
                          title: Text(
                            isShift
                                ? '$assignedName\'s Shift'
                                : isTimeOff
                                    ? '$assignedName\'s Time Off'
                                    : 'Event',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Starts: $timeStart'),
                              Text('Ends: $timeEnd'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            assignedEmail != globals.currentUser.email
                                ? OutlinedButton(
                                    child: const Text(
                                      'Request Trade',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 136, 0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      http.Response response;
                                      try {
                                        response = await http.post(
                                          Uri.parse(globals.httpURL),
                                          body: json.encode(
                                            {
                                              'key': 'trade_request_create',
                                              'sender_name':
                                                  globals.currentUser.name,
                                              'sender_email':
                                                  globals.currentUser.email,
                                              'recipient_name': assignedName,
                                              'recipient_email': assignedEmail,
                                              'shift_start_time': timeStart,
                                              'shift_end_time': timeEnd
                                            },
                                          ),
                                        );
                                        debugPrint(
                                            'response.body = ${response.body}');
                                      } catch (e) {
                                        globals.showSnackBar(context,
                                            'Network Communication Error');
                                        return;
                                      }

                                      if (response.statusCode == 200) {
                                        debugPrint(
                                            'Creating Task: http.post OK');
                                        // ignore: use_build_context_synchronously
                                        globals.showSnackBar(
                                            context, 'Trade Request Created');
                                      } else {
                                        debugPrint(
                                            'Creating Task: http.post BAD');
                                        // ignore: use_build_context_synchronously
                                        globals.showSnackBar(context,
                                            'Server Communication Error');
                                      }
                                    },
                                  )
                                : const SizedBox(height: 0, width: 0),
                            const SizedBox(width: 20),
                            OutlinedButton(
                              child: const Text(
                                'Cancel Event',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                http.Response response;
                                try {
                                  response = await http.post(
                                    Uri.parse(globals.httpURL),
                                    body: json.encode(
                                      {
                                        'key': 'event_delete',
                                        'teamID': globals.currentTeam.teamID,
                                        // Enough information to delete the correct event?
                                        'time_start': timeStart,
                                        'assigned_email': assignedEmail,
                                      },
                                    ),
                                  );
                                  debugPrint(
                                      'response.body = ${response.body}');
                                } catch (e) {
                                  globals.showSnackBar(
                                      context, 'Network Communication Error');
                                  return;
                                }

                                if (response.statusCode == 200) {
                                  debugPrint('Creating Task: http.post OK');
                                  // ignore: use_build_context_synchronously
                                  globals.showSnackBar(
                                      context, 'Event Canceled');
                                } else {
                                  debugPrint('Creating Task: http.post BAD');
                                  // ignore: use_build_context_synchronously
                                  globals.showSnackBar(
                                      context, 'Server Communication Error');
                                }

                                setState(() {
                                  fetchEvents().then((value) {
                                    setState(() {
                                      _events.clear();
                                      _events.addAll(value);
                                    });
                                  });
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: _events.length,
            ),
          ),
        ]),
      ),
    );
  }
}
