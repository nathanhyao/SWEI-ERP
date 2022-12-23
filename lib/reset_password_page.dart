import 'package:shay_app/services/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final double textFieldWidth = 270;

  bool optInitialized = false;
  bool secureText = true;

  final String localIPAddress = globals.httpURL;

  final TextEditingController _controllerEmail = TextEditingController();
  // final TextEditingController _controllerOTP = TextEditingController();
  // final TextEditingController _controllerNewPassword = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _controllerEmail.text.trim());
    } on FirebaseAuthException catch (e) {
      globals.showSnackBar(context, 'Account Doesn\'t Exist');
      return;
    }
    // ignore: use_build_context_synchronously
    globals.showSnackBar(context, 'Password Reset Link Sent');
    // Later used during login to reset PW in SQL Server records
    debugPrint('Reset Password in SQL Server: ARMED');
    globals.isResetPassword = true;
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
              const Text(
                'Forgot Your Password?',
                style: TextStyle(
                  color: Colors.cyan,
                  fontFamily: 'Inter',
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Enter your email and we will\nsend you a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: textFieldWidth,
                //Email
                child: TextField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    // suffixIcon: TextButton(
                    //   onPressed: () {},
                    //   child: const Text('Send Code'),
                    // ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),

              // const SizedBox(height: 10),

              // SizedBox(
              //   width: textFieldWidth,
              //   // Password
              //   child: TextField(
              //     controller: _controllerNewPassword,
              //     decoration: InputDecoration(
              //       hintText: 'New Password',
              //       hintStyle: const TextStyle(
              //         fontSize: 20,
              //       ),
              //       border: const OutlineInputBorder(),
              //       fillColor: Colors.white,
              //       filled: true,
              //       suffixIcon: IconButton(
              //         icon: secureText
              //             ? const Icon(Icons.visibility_off)
              //             : const Icon(Icons.visibility),
              //         onPressed: () => setState(() => secureText = !secureText),
              //       ),
              //     ),
              //     obscureText: secureText,
              //   ),
              // ),

              // const SizedBox(height: 10),

              // SizedBox(
              //   width: textFieldWidth,
              //   //Very Email (One time password)
              //   child: TextField(
              //     controller: _controllerOTP,
              //     decoration: const InputDecoration(
              //       hintText: 'Code',
              //       hintStyle: TextStyle(
              //         fontSize: 20,
              //       ),
              //       border: OutlineInputBorder(),
              //       fillColor: Colors.white,
              //       filled: true,
              //     ),
              //   ),
              // ),

              const SizedBox(height: 15),

              ///////////////////
              /// Create Account Button
              ///////////////////
              ElevatedButton(
                onPressed: passwordReset,
                child: const Text("Send Link"),
                // onPressed: () async {
                //   // If any fields are empty, don't continue
                //   if (_controllerNewPassword.text.isEmpty ||
                //       _controllerEmail.text.isEmpty ||
                //       _controllerOTP.text.isEmpty) {
                //     globals.showSnackBar(context, 'Blank Field Not Allowed');
                //     return;
                //   }

                //   // Check for minimum password length (Required by Firebase Auth)
                //   if (_controllerNewPassword.text.trim().length < 6) {
                //     globals.showSnackBar(
                //         context, 'Minimum Password Length is 6');
                //     return;
                //   }

                //   http.Response response;
                //   try {
                //     response = await http.post(
                //       Uri.parse(globals.httpURL),
                //       body: json.encode(
                //         {
                //           'key': 'password_reset',
                //           'email': _controllerEmail.text,
                //           'new_password': _controllerNewPassword.text
                //         },
                //       ),
                //     );
                //     // debugPrint('response.body = ${response.body}');
                //   } catch (e) {
                //     globals.showSnackBar(
                //         context, 'Network Communication Error');
                //     return;
                //   }

                //   if (response.statusCode == 200) {
                //     debugPrint('Account Registration: http.post OK');

                //     // ignore: use_build_context_synchronously
                //     globals.showSnackBar(context, 'New Password Set');
                //   } else {
                //     debugPrint('Account Registration: http.post BAD');
                //   }
                // },
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
                  child: const Text("Back to Login"),
                ),
              ),

              // const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
