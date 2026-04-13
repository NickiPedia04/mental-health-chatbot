import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/login_or_register.dart';
import 'package:mental_app_support/widgets/custom_navBottomBar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user has logged in
          if (snapshot.hasData) {
            return CustomNavbottombar();
          }
          // user has not logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
