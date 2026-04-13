import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Log Out Function
  void logOutFunction() {
    // log out
    final authServ = AuthService();
    authServ.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Home Page'),
            IconButton(onPressed: logOutFunction, icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}
