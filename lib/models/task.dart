class Task {
  String title = '';
  String assignedName = '';
  String isInProgress = '';

  Task(this.title, this.isInProgress, this.assignedName);

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    assignedName = json['name'];
    isInProgress = json['activity'];
  }
  // Debug: in Dart, 1 or 0 cannot be used as boolean. Only true or false
}
