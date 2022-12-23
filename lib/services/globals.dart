library globals;

import 'package:email_auth/email_auth.dart';
import 'package:shay_app/models/team.dart';
import 'package:shay_app/models/user.dart';
import 'package:flutter/material.dart';

// General global data with default values

bool isLoggedIn = false;
User currentUser = User('userName', 'userEmail', 'userPassword', 'privilege');
Team currentTeam = Team('teamName', 0);

// Firebase Authentication Debugging
String? errorMessage = '';

/// Put your IPv4 Address Here:
///
/// Check on Windows: in terminal type ipconfig
/// Check on Mac:     in terminal type ifconfig
///
/// Localhost Windows Desktop 127.0.0.1
/// Localhost Android Emulator 10.0.2.2
String localIPAddress = '10.0.0.38';
String portNumber = '5000';

// URL to send to: comes from a Flask application.
String httpURL = 'http://$localIPAddress:$portNumber';
// String httpURL = 'https://shay-app-server.herokuapp.com/';

// EmailJS Resource URL (email verifications)
String emailURL = 'https://api.emailjs.com/api/v1.0/email/send';
String serviceID = 'service_sbc6vzg';
String templateID = 'template_3o9oqcu';
String userID = '3XkqvL0KFtI5ftrUg';
int otpLength = 5;

// Resetting password
bool isResetPassword = false;

// Email Authenticator Object
EmailAuth emailAuth = EmailAuth(sessionName: "Shay App");

// JWT Token for Firebase Auth (temp?, could be currentUser property)
String? customToken = 'jwt_goes_here_on_login_or_registration';

// Default profile picture URL
String defaultProfilePictureURL =
    'https://i.pinimg.com/originals/36/fa/7b/36fa7b46c58c94ab0e5251ccd768d669.jpg';

// Detect if using Mobile Device (Android or iOS)
bool isMobileDevice(BuildContext context) {
  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
  return isIOS || isAndroid;
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
