class Event {
  String timeStart = ''; // DateTime Format: yyyy-MM-dd HH:mm
  String timeEnd = ''; // DateTime Format: yyyy-MM-dd HH:mm

  // The below are properties of shifts or time-off events
  bool isShift = false;
  bool isTimeOff = false;
  String assignedName = '';
  String assignedEmail = '';

  Event(
    this.timeStart,
    this.timeEnd,
    this.isShift,
    this.isTimeOff,
    this.assignedName,
    this.assignedEmail,
  );

  Event.fromJson(Map<String, dynamic> json) {
    timeStart = json['time_start']; // DateTime Format: yyyy-MM-dd HH:mm
    timeEnd = json['time_end']; // DateTime Format: yyyy-MM-dd HH:mm

    isShift = json['is_shift'];
    isTimeOff = json['is_time_off'];
    assignedName = json['assigned_name'];
    assignedEmail = json['assigned_email'];
  }
}
