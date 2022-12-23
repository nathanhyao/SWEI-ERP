import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
// Firebase Authentication and Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isObscurePassword = true;
  String pwExample = 'Change Password Here';
  String pwExampleObscure = '********************';
  TextEditingController nameController =
      TextEditingController(text: globals.currentUser.name);
  TextEditingController emailController =
      TextEditingController(text: globals.currentUser.email);
  TextEditingController pwController =
      TextEditingController(text: globals.currentUser.password);

  final double textFieldWidth = 270;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/blank-user-profile-2.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Adjust My Account Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: textFieldWidth,
                ////////////////////////////////////////////////
                /// Name
                ////////////////////////////////////////////////
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter New Name',
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
              SizedBox(
                width: textFieldWidth,
                ////////////////////////////////////////////////
                /// Email
                ////////////////////////////////////////////////
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter New Email',
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
              SizedBox(
                width: textFieldWidth,
                ////////////////////////////////////////////////
                /// Password
                ////////////////////////////////////////////////
                child: TextField(
                  controller: pwController,
                  obscureText: isObscurePassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscurePassword = !isObscurePassword;
                        });
                      },
                    ),
                    labelText: 'Enter New Password',
                    hintStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate back to home page. Don't save (cancel)
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        ////////////////////////////////////////////////
                        /// Password
                        ////////////////////////////////////////////////
                        if (pwController.text != globals.currentUser.password &&
                            pwController.text != "") {
                          // Check for minimum password length (Required by Firebase Auth)
                          if (pwController.text.trim().length < 6) {
                            globals.showSnackBar(
                                context, 'Minimum Password Length is 6');
                            return;
                          }

                          // Update in SQL Server Database
                          http.Response response = await http.post(
                            Uri.parse(globals.httpURL),
                            body: json.encode(
                              {
                                'key': 'password_reset',
                                'email': globals.currentUser.email,
                                'new_password': pwController.text
                              },
                            ),
                          );

                          // Update client-side tracking variables
                          globals.currentUser.password = pwController.text;

                          // Update for Firebase Authentication
                          if (FirebaseAuth.instance.currentUser != null) {
                            await FirebaseAuth.instance.currentUser
                                ?.updatePassword(pwController.text);
                          }
                        }

                        ////////////////////////////////////////////////
                        /// Email
                        ////////////////////////////////////////////////
                        if (emailController.text != globals.currentUser.email &&
                            emailController.text != "") {
                          // TODO: Check for Email Formatting? => Verify real email?

                          // Update in SQL Server Database
                          http.Response response = await http.post(
                            Uri.parse(globals.httpURL),
                            body: json.encode(
                              {
                                'key': 'email_reset',
                                'email': globals.currentUser.email,
                                'new_email': emailController.text
                              },
                            ),
                          );

                          // Update client-side tracking variables
                          globals.currentUser.email = emailController.text;

                          // Update for Firebase Authentication
                          if (FirebaseAuth.instance.currentUser != null) {
                            await FirebaseAuth.instance.currentUser
                                ?.updateEmail(emailController.text);
                          }
                        }

                        ////////////////////////////////////////////////
                        /// Name
                        ////////////////////////////////////////////////
                        if (nameController.text != globals.currentUser.name &&
                            nameController.text != "") {
                          http.Response response = await http.post(
                            Uri.parse(globals.httpURL),
                            body: json.encode(
                              {
                                'key': 'name_reset',
                                'email': globals.currentUser.email,
                                'new_name': nameController.text
                              },
                            ),
                          );
                          globals.currentUser.name = nameController.text;

                          if (FirebaseAuth.instance.currentUser != null) {
                            await FirebaseAuth.instance.currentUser
                                ?.updateDisplayName(nameController.text);

                            // Firestore tracks name. Must update in Firestore too
                            final firestoreInstance =
                                FirebaseFirestore.instance;
                            firestoreInstance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              "firstName": globals.currentUser.name
                            }).then((value) {
                              debugPrint('Firestore User Name Updated');
                            });
                          }
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  icon: Icon(
                    isObscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
