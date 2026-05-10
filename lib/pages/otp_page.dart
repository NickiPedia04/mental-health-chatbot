import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/pages/change_password_page.dart';

class OtpPage extends StatefulWidget {
  final String reqEmail;
  const OtpPage({super.key, required this.reqEmail});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> pin = List.generate(
    5,
    (_) => TextEditingController(),
  );

  String combineOtp() {
    return pin.map((p) => p.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          width: 310,
          height: 195,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        controller: pin[0],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "x",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        controller: pin[1],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "x",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        controller: pin[2],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "x",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        controller: pin[3],
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "x",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: TextFormField(
                        showCursor: false,
                        controller: pin[4],
                        onChanged: (value) {
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "x",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.6,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 7),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    RichText(
                      text: TextSpan(
                        text: "Resend Code",
                        style: TextStyle(fontSize: 11, color: Color(0xFF0084FF)),
                        children: [
                          TextSpan(
                            text: " to ${widget.reqEmail} after XX:XX",
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 7),

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
                        final otp = combineOtp();
                        final isValid = await AuthService().verifyOTP(
                          widget.reqEmail,
                          otp,
                        );

                        if (isValid) {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ResetPasswordLinkSentDialog(),
                          );
                        } else {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) =>
                                AlertDialog(title: Text('Otp not valid')),
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

class ResetPasswordLinkSentDialog extends StatelessWidget {
  const ResetPasswordLinkSentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 310,
        height: 145,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                "Password reset link has been sent to your email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Container(
                  width: 245,
                  height: 51,
                  decoration: BoxDecoration(
                    color: Color(0xFF2ED53C),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
