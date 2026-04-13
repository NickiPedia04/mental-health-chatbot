import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_gate.dart';
import 'package:mental_app_support/firebase_options.dart';
import 'package:mental_app_support/pages/change_password_page.dart';
import 'package:mental_app_support/pages/forgot_password_page.dart';
import 'package:mental_app_support/pages/home_page.dart';
import 'package:mental_app_support/pages/otp_page.dart';
import 'package:mental_app_support/pages/settings_page.dart';
import 'package:mental_app_support/themes/light_mode.dart';
import 'package:mental_app_support/widgets/custom_navBottomBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: AuthGate(),
      // main page ^^
      home: AuthGate(),
      theme: lightMode,
    );
  }
}
