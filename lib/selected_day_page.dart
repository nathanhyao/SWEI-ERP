// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:shay_app/selected_event_page.dart';
// import 'package:time_planner/time_planner.dart';
// import 'add_calender_event_page.dart';
// import 'package:shay_app/services/globals.dart' as globals;
// import 'package:http/http.dart' as http;
// import 'models/event.dart';

// class SelectedDay extends StatefulWidget {
//   final String day;
//   const SelectedDay({super.key, required this.day});

//   @override
//   State<SelectedDay> createState() => _SelectedDayState();
// }

// class _SelectedDayState extends State<SelectedDay> {
//   final List<Event> _events = [];

//   Future fetchEvents() async {
//     http.Response response;
//     try {
//       response = await http.post(
//         Uri.parse(globals.httpURL),
//         body: json.encode(
//           {
//             'key': 'event_fetch',
//             'teamID': globals.currentTeam.teamID,
//           },
//         ),
//       );
//       // debugPrint(response.body);
//     } catch (e) {
//       globals.showSnackBar(context, 'Network Communication Error');
//       return;
//     }

//     // Parse into Event objects, store into 'event' list
//     var events = <Event>[];

//     Event newEvent = new Event("2022-12-07", "9", "30", "90", "Testname", "testDescription", "cackler");
//     if (newEvent.date == widget.day) {
//         events.add(newEvent);
//     }

//     if (response.statusCode == 200) {
//       // http returns 200 means OK
//       debugPrint('Fetching Events: http.get OK');

//       var eventsJson = json.decode(response.body);
//       for (var eventJson in eventsJson) {
//         if (Event.fromJson(eventJson).date == widget.day) {
//           events.add(Event.fromJson(eventJson));
//         }
//       }
//     } else {
//       debugPrint('Fetching Events: http.get BAD');
//     }

//     return events;
//   }

//   @override
//   void initState() {
//     fetchEvents().then((value) {
//       // fetchEvents() is asynchronous. Use .then() to wait for it to finish
//       setState(() {
//         _events.addAll(value);
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed('/home/calendar/create');
//         },
//         tooltip: 'Create New Event',
//         child: const Icon(Icons.add),
//       ),
//       appBar:
//           AppBar(
//             elevation: 1,
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             title: Text(widget.day), 
//             centerTitle: true,
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       fetchEvents().then((value) {
//                         setState(
//                           () {
//                             _events.clear();
//                             _events.addAll(value);
//                           },
//                         );
//                       });
//                     });
//                   },
//                   child: const Icon(Icons.refresh),
//                 ),
//               ),
//             ],
//           ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: ListView.builder(
//           itemBuilder: (context, index) {
//             var hourAmount = _events[index].hourAmount;
//             var minuteAmount = _events[index].minuteAmount;
//             var durationAmount = _events[index].durationAmount;
//             var actualEventName = _events[index].actualEventName;
//             var description = _events[index].description;
//             var userName = _events[index].userName;

//             return Card(
//               elevation: 2.5,
//               child: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ListTile(
//                       leading: const Icon(
//                         Icons.timer,
//                         size: 35,
//                       ),
//                       title: Text(
//                         actualEventName,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Assigned to $userName'),
//                           Text('Start: $hourAmount:$minuteAmount'),
//                           Text('Lasts for $durationAmount minutes')
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         OutlinedButton(
//                           child: const Text(
//                             'View Description',
//                             style: TextStyle(color: Colors.blueAccent),
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                                 MaterialPageRoute(
//                                   builder: ((context) =>
//                                     new EventPage(eventName: actualEventName, description: description))));
//                           },
//                         ),
//                         OutlinedButton(
//                           child: const Text(
//                             'Request Shift',
//                             style: TextStyle(color: Colors.blueAccent),
//                           ),
//                           onPressed: () async {
//                             http.Response response;
//                             try {
//                               // http to server to update event request
//                               response = await http.post(
//                                 Uri.parse(globals.httpURL),
//                                 body: json.encode(
//                                   {
//                                     'key': 'event_request',
//                                     'title': actualEventName,
//                                     'name': globals.currentUser.name,
//                                   },
//                                 ),
//                               );
//                               debugPrint('response.body = ${response.body}');
//                             } catch (e) {
//                               globals.showSnackBar(
//                                   context, 'Network Communication Error');
//                               return;
//                             }


//                             if (response.statusCode == 200) {
//                               debugPrint('Requesting Event: http.post OK');

//                               // ignore: use_build_context_synchronously
//                               globals.showSnackBar(
//                                   context, 'Event Requested');
//                             } else {
//                               debugPrint('Requesting Event: http.post BAD');

//                               // ignore: use_build_context_synchronously
//                               globals.showSnackBar(
//                                   context, 'Server Communication Error');
//                               return;
//                             }

//                             setState(() {
//                               fetchEvents().then((value) {
//                                 setState(() {
//                                   _events.clear();
//                                   _events.addAll(value);
//                                 });
//                               });
//                             });
//                           },
//                         ),
                        
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//           itemCount: _events.length,
//         ),
//       ),
//     );
//   }
// }
