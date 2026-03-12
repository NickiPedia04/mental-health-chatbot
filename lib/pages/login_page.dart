import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/components/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  // TextFieldListeners
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final void Function() onTap;

  LoginPage({super.key, required this.onTap});

  // Login Function
  void loginFunction(BuildContext context) async {
    // auth
    final authServ = AuthService();

    // try login
    try {
      await authServ.signInEmailPassword(
        _emailController.text,
        _passController.text,
      );
    }
    // catch err
    catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            SizedBox(height: 30),

            // welcome
            Text(
              "Welcome Back",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),

            SizedBox(height: 30),

            // username / email textfield
            CustomTextfield(
              hintText: 'Email',
              obscureText: false,
              textController: _emailController,
            ),

            SizedBox(height: 10),

            // pass textfield
            CustomTextfield(
              hintText: 'Password',
              obscureText: true,
              textController: _passController,
            ),

            SizedBox(height: 5),

            // register now textbutton
            Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // login button
            CustomButton(
              textButton: 'LOGIN',
              onTap: () => loginFunction(context),
            ),
          ],
        ),
      ),
    );
  }
}
