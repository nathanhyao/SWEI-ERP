import 'package:flutter/material.dart';
import 'package:shay_app/models/request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shay_app/services/globals.dart' as globals;

class ShiftTradePage extends StatefulWidget {
  const ShiftTradePage({super.key});
  @override
  State<ShiftTradePage> createState() => _ShiftTradePageState();
}

class _ShiftTradePageState extends State<ShiftTradePage> {
  final List<Request> _incomingRequests = [];
  final List<Request> _outgoingRequests = [];

  // Fetch Incoming Shift Trade Requests
  Future fetchIncomingRequests() async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'incoming_trade_request_fetch',
            'email': globals.currentUser.email,
            'teamID': globals.currentTeam.teamID,
          },
        ),
      );
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }
    var incomingRequests = <Request>[];
    if (response.statusCode == 200) {
      debugPrint('Fetching Requests: http.get OK');
      var requestsJson = json.decode(response.body);
      debugPrint(response.body);
      // Add all relevant objects to the list
      for (var requestJson in requestsJson) {
        incomingRequests.add(Request.fromJson(requestJson));
      }
    } else {
      debugPrint('Fetching Requests: http.get BAD');
    }
    return incomingRequests;
  }

  // Fetch Outgoing Shift Trade Requests
  Future fetchOutgoingRequests() async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'outgoing_trade_request_fetch',
            'email': globals.currentUser.email,
            'teamID': globals.currentTeam.teamID,
          },
        ),
      );
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }
    var outgoingRequests = <Request>[];
    if (response.statusCode == 200) {
      debugPrint('Fetching Requests: http.get OK');
      var requestsJson = json.decode(response.body);
      debugPrint(response.body);
      // Add all relevant objects to the list
      for (var requestJson in requestsJson) {
        outgoingRequests.add(Request.fromJson(requestJson));
      }
    } else {
      debugPrint('Fetching Requests: http.get BAD');
    }
    return outgoingRequests;
  }

  @override
  void initState() {
    // Fetch user's incoming requests
    fetchIncomingRequests().then((value) {
      setState(() {
        _incomingRequests.addAll(value);
      });
    });
    // Fetch user's outgoing requests
    fetchOutgoingRequests().then((value) {
      setState(() {
        _outgoingRequests.addAll(value);
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
        title: const Text('Shift Trades'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.refresh),
              onTap: () {
                setState(() {
                  // When page is refreshed, re-retrieve incoming and outgoing requests
                  fetchIncomingRequests().then((value) {
                    setState(
                      () {
                        _incomingRequests.clear();
                        _incomingRequests.addAll(value);
                      },
                    );
                  });
                  fetchOutgoingRequests().then((value) {
                    setState(
                      () {
                        _outgoingRequests.clear();
                        _outgoingRequests.addAll(value);
                      },
                    );
                  });
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              color: Colors.blue[100],
              height: 40,
              child: Row(
                children: const [
                  SizedBox(width: 20),
                  Center(
                    child: Text(
                      'Incoming',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_double_arrow_left),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var senderName = _incomingRequests[index].senderName;
                  var senderEmail = _incomingRequests[index].senderEmail;
                  var recipientName = _incomingRequests[index].recipientName;
                  var recipientEmail = _incomingRequests[index].recipientEmail;
                  var shiftStartTime = _incomingRequests[index].shiftStartTime;
                  var shiftEndTime = _incomingRequests[index].shiftEndTime;

                  return Card(
                    elevation: 2.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.compare_arrows,
                              size: 35,
                            ),
                            title: Text(
                              '$senderName wants your shift',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shift Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.red,
                                      ),
                                    ),
                                    Text('Start: $shiftStartTime'),
                                    Text('End: $shiftEndTime'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlinedButton(
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  http.Response response;
                                  try {
                                    response = await http.post(
                                      Uri.parse(globals.httpURL),
                                      body: json.encode(
                                        {
                                          'key': 'trade_request_delete',
                                          'sender_name': senderName,
                                          'sender_email': senderEmail,
                                          'recipient_name': recipientName,
                                          'recipient_email': recipientEmail,
                                          'shift_start_time': shiftStartTime,
                                          'shift_end_time': shiftEndTime,
                                          'teamID': globals.currentTeam.teamID,
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
                                        context, 'Trade Declined');
                                  } else {
                                    debugPrint('Creating Task: http.post BAD');
                                    // ignore: use_build_context_synchronously
                                    globals.showSnackBar(
                                        context, 'Something Went Wrong');
                                    return;
                                  }

                                  setState(() {
                                    fetchIncomingRequests().then((value) {
                                      setState(() {
                                        _incomingRequests.clear();
                                        _incomingRequests.addAll(value);
                                      });
                                    });
                                  });
                                },
                              ),
                              const SizedBox(width: 20),
                              OutlinedButton(
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () async {
                                  http.Response response;
                                  try {
                                    response = await http.post(
                                      Uri.parse(globals.httpURL),
                                      body: json.encode(
                                        {
                                          'key': 'trade_request_accept',
                                          'sender_name': senderName,
                                          'sender_email': senderEmail,
                                          'recipient_name': recipientName,
                                          'recipient_email': recipientEmail,
                                          'shift_start_time': shiftStartTime,
                                          'shift_end_time': shiftEndTime,
                                          'teamID': globals.currentTeam.teamID,
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
                                        context, 'Trade Accepted');
                                  } else {
                                    debugPrint('Creating Task: http.post BAD');
                                    // ignore: use_build_context_synchronously
                                    globals.showSnackBar(
                                        context, 'Server Communication Error');
                                  }

                                  setState(() {
                                    fetchIncomingRequests().then((value) {
                                      setState(() {
                                        _incomingRequests.clear();
                                        _incomingRequests.addAll(value);
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
                itemCount: _incomingRequests.length,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              color: Colors.green[100],
              height: 40,
              child: Row(
                children: const [
                  SizedBox(width: 20),
                  Center(
                    child: Text(
                      'Outgoing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_double_arrow_right),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var senderName = _outgoingRequests[index].senderName;
                  var senderEmail = _outgoingRequests[index].senderEmail;
                  var recipientName = _outgoingRequests[index].recipientName;
                  var recipientEmail = _outgoingRequests[index].recipientEmail;
                  var shiftStartTime = _outgoingRequests[index].shiftStartTime;
                  var shiftEndTime = _outgoingRequests[index].shiftEndTime;

                  return Card(
                    elevation: 2.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.compare_arrows,
                              size: 35,
                            ),
                            title: Text(
                              'You want $recipientName\'s shift',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Text(
                                  'Pending',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shift Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // color: Colors.red,
                                      ),
                                    ),
                                    Text('Start: $shiftStartTime'),
                                    Text('End: $shiftEndTime'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlinedButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  http.Response response;
                                  try {
                                    response = await http.post(
                                      Uri.parse(globals.httpURL),
                                      body: json.encode(
                                        {
                                          'key': 'trade_request_delete',
                                          'sender_name': senderName,
                                          'sender_email': senderEmail,
                                          'recipient_name': recipientName,
                                          'recipient_email': recipientEmail,
                                          'shift_start_time': shiftStartTime,
                                          'shift_end_time': shiftEndTime,
                                          'teamID': globals.currentTeam.teamID,
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
                                        context, 'Request Canceled');
                                  } else {
                                    debugPrint('Creating Task: http.post BAD');
                                    // ignore: use_build_context_synchronously
                                    globals.showSnackBar(
                                        context, 'Something Went Wrong');
                                    return;
                                  }

                                  setState(() {
                                    fetchOutgoingRequests().then((value) {
                                      setState(() {
                                        _outgoingRequests.clear();
                                        _outgoingRequests.addAll(value);
                                      });
                                    });
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _outgoingRequests.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
