class Pay {
  String week = '';
  String assignedName = '';
  String payPeriodHours = '';
  String income = '';
  bool isInProgress = false;

  Pay(this.week, this.isInProgress, this.assignedName);

  Pay.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    assignedName = json['name'];
    isInProgress = json['weekID'] != 0 ? true : false;
    payPeriodHours = json['hours'];
    income = json['income'];
  }
}
