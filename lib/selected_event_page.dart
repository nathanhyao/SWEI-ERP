import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  
  String description = "";
  String eventName = "";

  EventPage({super.key, required this.eventName, required this.description});

  @override
  State<EventPage> createState() => _EventPageState();
}


class _EventPageState extends State<EventPage> {

  String getEventName(String widgetEvent) {
    String substring = "";
      for (int i = 0; i < widgetEvent.length; i++) {
        if (widgetEvent[i] == ':') {
            return substring;
        }
        else {
            substring = substring + widgetEvent[i];
        }
      }
      return substring;
  }
  String getEventDuration(String widgetEvent) {
      String substring = "";
      int seperatorVal = 0;
      for (int i = 0; i < widgetEvent.length; i++) {
        if (widgetEvent[i] == ':') {
            if (seperatorVal == 3) {
              return substring;
            }
            else {
                substring = "";
                seperatorVal++;
            }
        }
        else {
            substring = substring + widgetEvent[i];
        }
      }
      return substring;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getEventName(widget.eventName)), centerTitle: true),
      body: Center(
        child: Text("Description: " + getEventDuration(widget.description))
      )
    );
  }
}