import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
// Firebase Core 1.6.0 Usage: FirebaseChatCore.instance.createUserInFirestore
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shay_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double textFieldWidth = 270;

  bool secureText = true;
  bool pwCorrect = true;

  String localIPAddress = globals.httpURL;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        globals.errorMessage = e.message;
      });
    }
  }

  // Temp
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontFamily: 'Inter',
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: textFieldWidth,
                  // Email
                  child: TextField(
                    controller: _controllerEmail,
                    decoration: const InputDecoration(
                      hintText: 'Email',
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
                  // Password
                  child: TextField(
                    controller: _controllerPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      // errorText: pwCorrect ? '' : 'email or password is incorrect',
                      border: const OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: secureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () =>
                            setState(() => secureText = !secureText),
                      ),
                    ),
                    obscureText: secureText,
                  ),
                ),

                const SizedBox(height: 15),

                ///////////////////
                /// Login Button
                ///////////////////
                ElevatedButton(
                  onPressed: () async {
                    if (_controllerPassword.text.isEmpty ||
                        _controllerEmail.text.isEmpty) {
                      globals.showSnackBar(context, 'Blank Field Not Allowed');
                      return;
                    }

                    // createUserWithEmailAndPassword();
                    await signInWithEmailAndPassword();

                    http.Response response;

                    // UPDATE: Use Firebase as PRIMARY authenticator.
                    // If the user used the reset password option, update in SQL Server too (in case)
                    debugPrint(globals.isResetPassword.toString());
                    if (globals.isResetPassword &&
                        FirebaseAuth.instance.currentUser != null) {
                      // Only tries if Firebase Authentication is already successful
                      try {
                        response = await http.post(
                          Uri.parse(globals.httpURL),
                          body: json.encode(
                            {
                              'key': 'password_reset',
                              'email': _controllerEmail.text,
                              'new_password': _controllerPassword.text,
                            },
                          ),
                        );
                        debugPrint('Reset Password in SQL Server: DEARMED');
                        globals.isResetPassword = false;
                        debugPrint('login reset password=${response.body}');
                        if (response.statusCode != 200) {
                          await FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          globals.showSnackBar(
                              context, 'Something Went Wrong. Try Again.');
                          return;
                        }
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        globals.showSnackBar(
                            context, 'Network Communication Error');
                        return;
                      }
                    }

                    // Try to login via SQL Server (password should have updated if necessary)
                    try {
                      response = await http.post(
                        Uri.parse(globals.httpURL),
                        body: json.encode(
                          {
                            'key': 'login',
                            'email': _controllerEmail.text,
                            'password': _controllerPassword.text
                          },
                        ),
                      );
                      debugPrint('response.body = ${response.body}');
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      globals.showSnackBar(
                          context, 'Network Communication Error');
                      return;
                    }

                    if (response.statusCode == 200 &&
                        FirebaseAuth.instance.currentUser != null) {
                      debugPrint('Login Attempt: http.post OK');

                      // Decode json response and begin tracking logged in user
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;

                      // Set globals to track now-logged-in user
                      globals.currentUser.email = _controllerEmail.text;
                      globals.currentUser.name = decoded['name'];
                      globals.currentUser.password = _controllerPassword.text;
                      globals.currentUser.privilege = 'User'; // temp

                      // Check logged in user data is correct (see DEBUG CONSOLE)
                      debugPrint('email =    ${globals.currentUser.email}');
                      debugPrint('name =     ${globals.currentUser.name}');
                      debugPrint('password = ${globals.currentUser.password}');
                      debugPrint('isAdmin =  ${globals.currentUser.privilege}');

                      // // Try custom token for Firebase Auth
                      // globals.customToken = decoded['custom_token'];
                      // // debugPrint('\nlogin token = ${globals.customToken}\n');

                      // // Authenticate user in firebase
                      // authenticateUserInFirebase(globals.customToken);
                      // // Check if Firebase auth is successful (may take a while)
                      // if (FirebaseAuth.instance.currentUser != null) {
                      //   debugPrint(FirebaseAuth.instance.currentUser?.uid);
                      // }

                      globals.isLoggedIn = true;

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed('/home');
                    } else if (response.statusCode == 400) {
                      debugPrint('Login Attempt: http.post BAD');

                      setState(() {
                        pwCorrect = false;
                        globals.showSnackBar(context, 'Invalid Credentials');
                      });
                    } else {
                      // ignore: use_build_context_synchronously
                      globals.showSnackBar(context, 'Invalid Credentials');
                      debugPrint('invalid login=${response.body}');
                      debugPrint('Something went wrong. Check response codes.');
                      return;
                    }

                    //////////////////////////////////////////////////////////////////
                    /// POTENTIAL ISSUE: One client might receive another client's
                    ///   expected response if the timing is bad.
                    ///
                    /// IF THIS IS AN ISSUE: Maybe find a way for flask to create an
                    ///   additional thread for each user. (Flask does this by default?)
                    ///
                    /// 2022 10 29 Issue Resolved
                    //////////////////////////////////////////////////////////////////
                  },
                  child: const Text("Log in"),
                ),

                const SizedBox(height: 10),

                ///////////////////
                /// Forgot Password Button
                ///////////////////
                SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login/reset');
                    },
                    child: const Text("Forgot password?"),
                  ),
                ),

                ///////////////////
                /// Create Account Navigation Button
                ///////////////////
                SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text("New user? Create an account"),
                  ),
                ),

                const SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void authenticateUserInFirebase(String token) async {
  try {
    // UNSURE: Does signInWithCustomToken expect a utf8 encoding?
    //         or should custom_token be cast like str(custom_token) on server?
    final userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(token);
    final user = userCredential.user;
    await user?.updateEmail(globals.currentUser.email);
    await user?.updateDisplayName(globals.currentUser.name);

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: globals.currentUser.name,
        id: userCredential.user!.uid, // UID from Firebase Authentication
        // imageUrl: 'assets/images/default-profile-picture1.jpg',
      ),
    );

    debugPrint("Sign-in successful.");
    debugPrint("User Credential=$userCredential");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "invalid-custom-token":
        debugPrint("The supplied token is not a Firebase custom auth token.");
        break;
      case "custom-token-mismatch":
        debugPrint("The supplied token is for a different Firebase project.");
        break;
      default:
        debugPrint("Unkown error.");
    }
  }
}
