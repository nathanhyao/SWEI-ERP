import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Clock Page - Idea
///
/// (1) Clocking in sends current time to server (server sends to DB).
///
/// (2) Clocking out sends current time to server (server sends to DB).
///
/// (3) After clocking in, timer starts running (displays time elapsed).
///
/// (4) Upon reloading the page, Flutter knows if current user is clocked in.
///
///   (a) If user is already clocked-in, perform calculation with clock-in time
///       and current time to initialize time-elapsed display and continue
///       showing the stopwatch running. User can see clock-out button.
///
///   (b) If user is not clocked-in, the usual page is displayed (time display
///       doesn't update and user can clock-in).
///
/// (5) Upon finishing shift, DB contains clock-in time and duration at minimum.

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String elapsedTime = '';
  String clockInTimeDisplay = '';
  bool isClockedIn = false;
  bool shiftEnded = false;

  TextStyle infoTextStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  // If user is clocked in, then retrieve time-elapsed
  Future fetchTime() async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'shift_fetch',
            'teamID': globals.currentTeam.teamID,
            'email': globals.currentUser.email,
          },
        ),
      );
      // debugPrint('response.body = ${response.body}');
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }

    if (response.statusCode == 200) {
      debugPrint('Shift Fetch: http.post OK');

      final responseDecoded =
          json.decode(response.body) as Map<String, dynamic>;

      if (responseDecoded['isClockedIn']) {
        isClockedIn = true;
        String time = responseDecoded['clockInTime'];

        DateTime clockInTime = DateTime.parse(time);
        DateTime currentTime = DateTime.now();
        Duration elapsedTime = currentTime.difference(clockInTime);

        clockInTimeDisplay = DateFormat.yMEd().add_jms().format(clockInTime);

        _stopWatchTimer.setPresetSecondTime(elapsedTime.inSeconds);
        _stopWatchTimer.onStartTimer();
      }
    } else if (response.statusCode == 400) {
      debugPrint('Shift Fetch: http.post BAD');
    } else {
      debugPrint('Something went wrong. Check response codes.');
    }
  }

  @override
  void initState() {
    fetchTime().then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.blueAccent,
        title: const Text('Clock In / Clock Out'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // StreamBuilder<int>: time display
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final value = snapshot.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);

                return Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            // Spacing between time display and buttons
            const SizedBox(
              height: 20,
            ),

            // Buttons widget hierarchy
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Start (Clock in)
                  Container(
                    // if isClockedIn, then show 'Clock out' option initially rather than 'Clock in' option.
                    // if shiftEnded, then remove 'Clock in' and 'Clock out' options. Display elapsed time.
                    child: shiftEnded
                        // Has the shiftEnded?

                        // If yes, display "Shift Completed"
                        ? Column(
                            children: const <Widget>[
                              Text(
                                'Shift Completed',
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                textAlign: TextAlign.center,
                                'Refresh the page to be\nable to clock-in again.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )

                        // If no, then...
                        // Is the user NOT clocked in?
                        : !isClockedIn

                            // If yes, display "Clock in" button
                            ?
                            // Start (Clock in)
                            Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Parse DateTime to correct formatting to be stored
                                      final DateTime now = DateTime.now();
                                      final DateFormat formatter =
                                          DateFormat('yyyy-MM-dd HH:mm:ss');
                                      final String formatted =
                                          formatter.format(now);

                                      // something like 2013-04-20
                                      debugPrint(formatted);

                                      http.Response response;
                                      try {
                                        response = await http.post(
                                          Uri.parse(globals.httpURL),
                                          body: json.encode(
                                            {
                                              'key': 'shift_start',
                                              'teamID':
                                                  globals.currentTeam.teamID,
                                              'email':
                                                  globals.currentUser.email,
                                              'clockInTime': formatted,
                                            },
                                          ),
                                        );
                                        // debugPrint('response.body = ${response.body}');
                                      } catch (e) {
                                        globals.showSnackBar(context,
                                            'Network Communication Error');
                                        return;
                                      }

                                      if (response.statusCode == 200) {
                                        debugPrint('Shift Start: http.post OK');
                                        setState(() {
                                          isClockedIn = true;
                                          clockInTimeDisplay = DateFormat.yMEd()
                                              .add_jms()
                                              .format(now);
                                          _stopWatchTimer.onStartTimer();
                                        });
                                      } else if (response.statusCode == 400) {
                                        debugPrint(
                                            'Shift Start: http.post BAD');
                                      } else {
                                        debugPrint(
                                            'Something went wrong. Check response codes.');
                                        return;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[400],
                                      textStyle: infoTextStyle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text('Clock In'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    textAlign: TextAlign.center,
                                    'Shift Not Started',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )

                            // If no, display "Clock out" button
                            :
                            // Stop (Clock out)
                            Column(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Parse DateTime to correct formatting to be stored
                                      final DateTime now = DateTime.now();
                                      final DateFormat formatter =
                                          DateFormat('yyyy-MM-dd HH:mm:ss');
                                      final String formatted =
                                          formatter.format(now);

                                      // something like 2013-04-20
                                      debugPrint(formatted);

                                      http.Response response;
                                      try {
                                        response = await http.post(
                                          Uri.parse(globals.httpURL),
                                          body: json.encode(
                                            {
                                              'key': 'shift_end',
                                              'teamID':
                                                  globals.currentTeam.teamID,
                                              'email':
                                                  globals.currentUser.email,
                                              'clockOutTime': formatted,
                                            },
                                          ),
                                        );
                                        // debugPrint('response.body = ${response.body}');
                                      } catch (e) {
                                        globals.showSnackBar(context,
                                            'Network Communication Error');
                                        return;
                                      }

                                      if (response.statusCode == 200) {
                                        debugPrint('Shift End: http.post OK');
                                        setState(() {
                                          isClockedIn = false;
                                          shiftEnded = true;
                                          _stopWatchTimer.onStopTimer();
                                        });
                                      } else if (response.statusCode == 400) {
                                        debugPrint('Shift End: http.post BAD');
                                      } else {
                                        debugPrint(
                                            'Something went wrong. Check response codes.');
                                        return;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      textStyle: infoTextStyle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text('Clock Out'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    textAlign: TextAlign.center,
                                    'Shift Started\n$clockInTimeDisplay',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
