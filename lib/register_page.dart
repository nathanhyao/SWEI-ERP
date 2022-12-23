import 'package:shay_app/services/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shay_app/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final double textFieldWidth = 270;

  bool optInitialized = false;
  bool secureText = true;

  final String localIPAddress = globals.httpURL;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerOTP = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String oneTimePassword = randomNumeric(globals.otpLength);

  void sendOTP() async {
    oneTimePassword = randomNumeric(globals.otpLength);
    final response = await http.post(
      Uri.parse(globals.emailURL),
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': globals.serviceID,
        'template_id': globals.templateID,
        'user_id': globals.userID,
        'template_params': {
          'user_email': _controllerEmail.text,
          'one_time_password': oneTimePassword,
        }
      }),
    );
    debugPrint('EmailJS Response=${response.body}');
  }

  bool verifyOTP() {
    return _controllerOTP.text == oneTimePassword;
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        globals.errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 175.0,
                width: 350.0,
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Image.asset('assets/images/shay.png'),
                ),
              ),

              const Text(
                'Create New Account',
                style: TextStyle(
                  color: Colors.cyan,
                  fontFamily: 'Inter',
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: textFieldWidth,
                //Username (Should be Name)
                child: TextField(
                  controller: _controllerName,
                  // maxLength: 30,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: textFieldWidth,
                //Email
                child: TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    suffixIcon: TextButton(
                      onPressed: sendOTP,
                      child: const Text('Send Code'),
                    ),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: textFieldWidth,
                // Password
                child: TextField(
                  controller: _controllerPassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: secureText
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () => setState(() => secureText = !secureText),
                    ),
                  ),
                  obscureText: secureText,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Click \'Send Code\' and verify the\ncode sent to the provided email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 2),

              SizedBox(
                width: textFieldWidth,
                //Very Email (One time password)
                child: TextField(
                  controller: _controllerOTP,
                  decoration: const InputDecoration(
                    hintText: 'Code',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ///////////////////
              /// Create Account Button
              ///////////////////
              ElevatedButton(
                onPressed: () async {
                  // If any fields are empty, don't continue
                  if (_controllerPassword.text.isEmpty ||
                      _controllerName.text.isEmpty ||
                      _controllerEmail.text.isEmpty ||
                      _controllerOTP.text.isEmpty) {
                    globals.showSnackBar(context, 'Blank Field Not Allowed');
                    return;
                  }

                  // Check for minimum password length (Required by Firebase Auth)
                  if (_controllerPassword.text.trim().length < 6) {
                    globals.showSnackBar(
                        context, 'Minimum Password Length is 6');
                    return;
                  }

                  // Email verification: check for otp correctness
                  if (!verifyOTP()) {
                    globals.showSnackBar(
                        context, 'Invalid Email Verification Code');
                    return;
                  }

                  http.Response response;
                  try {
                    response = await http.post(
                      Uri.parse(globals.httpURL),
                      body: json.encode(
                        {
                          'key': 'register',
                          'name': _controllerName.text,
                          'email': _controllerEmail.text,
                          'password': _controllerPassword.text
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
                    debugPrint('Account Registration: http.post OK');

                    // Begin tracking new user after login
                    globals.currentUser.email = _controllerEmail.text;
                    globals.currentUser.name = _controllerName.text;
                    globals.currentUser.password = _controllerPassword.text;
                    globals.currentUser.privilege = 'User'; // temp

                    // Check logged in user data is correct (see DEBUG CONSOLE)
                    debugPrint('email =    ${globals.currentUser.email}');
                    debugPrint('name =     ${globals.currentUser.name}');
                    debugPrint('password = ${globals.currentUser.password}');
                    debugPrint('isAdmin =  ${globals.currentUser.privilege}');

                    await createUserWithEmailAndPassword();

                    globals.isLoggedIn = true;

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed('/home');
                  } else {
                    debugPrint('Account Registration: http.post BAD');
                  }
                },
                child: const Text("Create Account"),
              ),

              const SizedBox(height: 10),

              ///////////////////
              /// Back Button
              ///////////////////
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Already have an account? Log in"),
                ),
              ),

              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
