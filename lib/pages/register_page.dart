import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/components/custom_passwordTextfield.dart';
import 'package:mental_app_support/components/custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  // TextFieldListeners
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final void Function() onPressed;

  RegisterPage({super.key, required this.onPressed});

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

            // username textfield
            CustomTextfield(
              hintText: 'Username',
              textController: _usernameController,
              horzonPadding: 50.0,
            ),

            SizedBox(height: 10),

            // email textfield
            CustomTextfield(
              hintText: 'Email',
              textController: _emailController,
              horzonPadding: 50.0,
            ),

            SizedBox(height: 10),

            // pass textfield
            CustomPasswordTextfield(
              hintText: 'Password',
              textController: _passController,
              horzonPadding: 50.0,
            ),

            SizedBox(height: 10),

            // confirm pass textfield
            CustomPasswordTextfield(
              hintText: 'Confirm password',
              textController: _confirmPassController,
              horzonPadding: 50.0,
            ),

            SizedBox(height: 10),

            // register button
            CustomButton(
              textButton: 'Sign Up',
              onTap: () => registerFunction(context),
            ),

            SizedBox(height: 15),

            Text(
              '- - - Or Register Using - - -',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.4),
              ),
            ),

            SizedBox(height: 15),

            // Google sign in
            GestureDetector(
              onTap: () async {
                // print('google sign in pressed');
                await AuthService().signInGoogle();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image(image: AssetImage('assets/google_icon.png')),
              ),
            ),

            // login now textbutton
            TextButton(
              onPressed: onPressed,
              child: Text(
                'Already Registered?',
                style: TextStyle(
                  color: Color(0xFF0084FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
