import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEvent extends StatefulWidget {

  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  bool _switchValue = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController durController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  String name = "";
  String desc = "";
  String hour = "";
  String dur = "";
  String min = "";
  String day = "";
  bool requestOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Create event"), centerTitle: true),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 25),
          const Text("Request off"),
          CupertinoSwitch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
                requestOff = value;
              });
            },
          ),
          const SizedBox(height: 25),
          const Text("Event Title:"),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Event Name',
              hintStyle: TextStyle(
                fontSize: 20,
              ),
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
            ),
            maxLength: 20,
          ),
          const Text("Event Description:"),
          TextField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
              )),
              const Text("Start Time (hour:minute):"),
              TextField(
                controller: hourController,
                decoration: const InputDecoration(
                  hintText: 'Ex. 6:30 for AM 18:30 for PM',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLength: 5,
              ),
              const Text("Duration in minutes:"),
              TextField(
                controller: durController,
                decoration: const InputDecoration(
                  hintText: 'Ex. 90',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLength: 4,
              ),
              const Text("Date:"),
              TextField(
                controller: dayController,
                decoration: const InputDecoration(
                  hintText: 'Ex. 2022-12-22',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLength: 10,
              ),
              // Create ElevatedButton to send information to server
              ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        descController.text.isEmpty ||
                        durController.text.isEmpty ||
                        hourController.text.isEmpty ||
                        dayController.text.isEmpty) {
                      showSnackBar(context, 'Blank Field Not Allowed');
                      return;
                    }
                    name = nameController.text;
                    desc = descController.text;
                    dur = durController.text;
                    hour = hourController.text;
                    day = dayController.text;
                    min = hour.substring(hour.indexOf(':') + 1);
                    hour = hour.substring(0, hour.indexOf(':'));
                    if (requestOff) {
                        name = "time off";
                    }

                    
                    http.Response response;
                    try {
                      response = await http.post(
                        Uri.parse(globals.httpURL),
                        body: json.encode(
                          {
                            'key': 'event_create',
                            'day': day,
                            'name': name,
                            'desc': desc,
                            'dur' : dur,
                            'hour' : hour,
                            'min' : min
                          },
                        ),
                      );
                      // debugPrint('response.body = ${response.body}');
                    } catch (e) {
                      globals.showSnackBar(
                          context, 'Network Communication Error');
                      return;
                    }
                    if (response.statusCode == 200) {
                      debugPrint('Create Event Successful: http.post OK');


                      // ignore: use_build_context_synchronously
                      globals.showSnackBar(context, 'Event Created');

                    } else if (response.statusCode == 400) {
                      debugPrint('Login Attempt: http.post BAD');

                      setState(() {
                        globals.showSnackBar(context, 'Error Creating Event');
                      });
                    } else {
                      debugPrint('Something went wrong. Check response codes.');
                      return;
                    }


                  },
                child: const Text("Create Event"),
              ),
          ]
        )
      )
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
