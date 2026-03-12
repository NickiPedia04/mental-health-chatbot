import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/components/custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  // TextFieldListeners
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final void Function() onTap;

  RegisterPage({super.key, required this.onTap});

  void registerFunction(BuildContext context) {
    // Register
    final _auth = AuthService();

    // pass matched, then register
    if (_passController.text == _confirmPassController.text) {
      try {} catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
      _auth.signUpUsernameEmailPassword(
        _usernameController.text,
        _emailController.text,
        _passController.text,
      );
    }
    // pass don't match, show error to match the pass
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('Pass don\'t match')),
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

            // username textfield
            CustomTextfield(
              hintText: 'Username',
              obscureText: false,
              textController: _usernameController,
            ),

            SizedBox(height: 10),

            // email textfield
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

            // confirm pass textfield
            CustomTextfield(
              hintText: 'Confirm password',
              obscureText: true,
              textController: _confirmPassController,
            ),
            SizedBox(height: 5),

            // Login page textbutton
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Already registered? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18),

            // login button
            CustomButton(
              textButton: 'REGISTER',
              onTap: () => registerFunction(context),
            ),
          ],
        ),
      ),
    );
  }
}
