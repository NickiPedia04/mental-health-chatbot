import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/components/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  // TextFieldListeners
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final void Function() onPressed;

  LoginPage({super.key, required this.onPressed});

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

            SizedBox(height: 10),

            // login button
            CustomButton(
              textButton: 'LOGIN',
              onTap: () => loginFunction(context),
            ),

            SizedBox(height: 15),

            // Google sign in
            GestureDetector(
              onTap: () async {
                // print('google sign in pressed');
                await AuthService().signInGoogle();
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image(image: AssetImage('assets/google_icon.png')),
              ),
            ),

            // register now textbutton
            TextButton(
              onPressed: onPressed,
              child: Text(
                'Not Registered?',
                style: TextStyle(
                  color: Color(0xFF0084FF),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF0084FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
