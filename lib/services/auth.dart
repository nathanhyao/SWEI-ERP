import 'package:shay_app/services/globals.dart' as globals;
// Firebase Authentication
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Firebase Core 1.6.0 Usage: FirebaseChatCore.instance.createUserInFirestore
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    debugPrint('Signed in with Email and Password');
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    debugPrint('Created User with Email and Password');

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: globals.currentUser.name,
        id: credential.user!.uid, // UID from Firebase Authentication
        imageUrl: globals.defaultProfilePictureURL,
      ),
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
