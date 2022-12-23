/// User Class - Idea
///
/// Use this class to bundle user information for encapsulation and organization

class User {
  String name = '';
  String email = '';
  String password = '';
  String privilege = '';

  /// Was thinking of creating a isClockedIn property.
  /// Was thinking: for now, let that be stored specific to the team in the DB

  User(this.name, this.email, this.password, this.privilege);

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    privilege = json['privilege'];
    // password = json['password'];
  }

  // String get getName {
  //   return name;
  // }

  // String get getEmail {
  //   return email;
  // }

  // String get getPassword {
  //   return password;
  // }

  // bool get getIsAdmin {
  //   return isAdmin;
  // }

  // set setName(String name) {
  //   this.name = name;
  // }

  // set setEmail(String email) {
  //   this.email = email;
  // }

  // set setPassword(String password) {
  //   this.password = password;
  // }

  // set setIsAdmin(bool isAdmin) {
  //   this.isAdmin = isAdmin;
  // }
}
