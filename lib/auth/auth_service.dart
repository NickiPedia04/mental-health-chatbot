import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  User? getCurrUser() {
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register
  Future<UserCredential> signUpUsernameEmailPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await addUserDetails(username, email);

      print('user details contains: $username and $email');

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // google sign in
  Future<User?> signInGoogle() async {
    try {
      print('Initializing Google Sign In');

      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            '644908706342-vv58e9rtakubkhomj9nr6elqqfclvuvf.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final googleCred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(googleCred);

      await addUserDetails(
        userCred.user!.displayName ?? 'No Name',
        userCred.user!.email ?? '',
      );

      print('Success: $userCred');

      return userCred.user;
    } catch (e) {
      print("Erorr: $e");
      return null;
    }
  }

  // add user's detail to firestore
  Future<void> addUserDetails(String username, String email) async {
    final user = _auth.currentUser;

    print(user?.uid);

    if (user == null) return;

    final db = FirebaseFirestore.instance
        .collection('user-details')
        .doc(user.uid);

    final snapshot = await db.get();

    if (!snapshot.exists) {
      await db.set({"email": email, "username": username});
      print('user saved to firestore');
    }
  }

  // verify existed account
  Future<bool> verifyEmail(String email) async {
    try {
      final checkEmail = await FirebaseFirestore.instance
          .collection('user-details')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return checkEmail.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // store otp
  Future<void> storeOTP(String email, String otp) async {
    await FirebaseFirestore.instance.collection('otp').doc(email).set({
      "otp": otp,
      "createdAt": Timestamp.now(),
    });
  }

  // send otp to email
  Future<void> sendEmail({
    required String userName,
    required String userEmail,
    required String otp,
    required String endTime,
  }) async {
    final serviceId = 'service_np3dq55';
    final templateId = 'template_2a5o4of';
    final userId = 'user_HWjDsRXcC7YMOzb9N';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service-id': serviceId,
        'template-id': templateId,
        'user-id': userId,
        'template-params': {
          'user_name': userName,
          'user_email': userEmail,
          'otp': otp,
          'end_time': endTime,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed: ${response.body}');
    }
  }

  // verify otp
  Future<bool> verifyOTP(String email, String inputtedCode) async {
    final docRef = FirebaseFirestore.instance.collection('otp').doc(email);

    final doc = await docRef.get();

    if (!doc.exists) return false;

    final data = doc.data();
    final savedCode = data?['otp'];
    final createdAt = data?['createdAt'];

    // if passed 5 mins
    if (Timestamp.now().seconds - createdAt.seconds > 300) {
      await docRef.delete();
      return false;
    }

    if (inputtedCode == savedCode) {
      await docRef.delete();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }

    return false;
  }
}
