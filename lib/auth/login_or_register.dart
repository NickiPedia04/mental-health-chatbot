import 'package:flutter/material.dart';
import 'package:mental_app_support/pages/login_page.dart';
import 'package:mental_app_support/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initialize login page as default
  bool isLoginPage = true;

  void changePages() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoginPage) {
      return LoginPage(onTap: changePages);
    } else {
      return RegisterPage(onTap: changePages);
    }
  }
}
