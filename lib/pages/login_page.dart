import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/components/custom_password_textfield.dart';
import 'package:mental_app_support/components/custom_textfield.dart';
import 'package:mental_app_support/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final void Function() onPressed;

  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextFieldListeners
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

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
              hintText: 'email@example.com',
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

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 53),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF0084FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // login button
            CustomButton(
              textButton: 'Sign In',
              onTap: () => loginFunction(context),
            ),

            SizedBox(height: 15),

            Text(
              '- - - Or Login Using - - -',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.4),
              ),
            ),

            SizedBox(height: 15),

            // Google sign in
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: GestureDetector(
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
            ),

            // register now textbutton
            TextButton(
              onPressed: widget.onPressed,
              child: Text(
                'Not Registered?',
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
