import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_textfield.dart';
import 'package:mental_app_support/pages/otp_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final authServ = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance.collection('user-details').doc();
  ForgotPasswordPage({super.key});

  String generateOTP() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  void goToOTP(BuildContext context) async {
    if (_emailController.toString().isNotEmpty) {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(reqEmail: _emailController.text),
          ),
        );
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          width: 310,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              CustomTextfield(
                hintText: 'Email',
                textController: _emailController,
                horzonPadding: 20.0,
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 125,
                        height: 51,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF2020),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final isEmailExist = AuthService().verifyEmail(
                          _emailController.text,
                        );

                        if (await isEmailExist) {
                          // ignore: use_build_context_synchronously
                          goToOTP(context);
                          AuthService().storeOTP(
                            _emailController.text,
                            generateOTP(),
                          );
                          // AuthService().sendEmail(
                          //   userName: userName,
                          //   userEmail: _emailController.text,
                          //   otp: generateOTP(),
                          //   endTime: endTime
                          // )
                        } else {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Email not registered'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 125,
                        height: 51,
                        decoration: BoxDecoration(
                          color: Color(0xff2ED53C),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
