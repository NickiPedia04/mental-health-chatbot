import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';
import 'package:mental_app_support/components/custom_textfield.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user-details')
            .doc(currUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userDetails = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 125, 0, 0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(userDetails['username']),
                    Text(userDetails['email']),

                    SizedBox(height: 50),

                    SizedBox(
                      height: 170,
                      width: 280,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Account',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => ChangeUsernameDialog(),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 280,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Change Username',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '>',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                'Preferences',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => ChangeThemeDialog(),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 280,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Theme',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '>',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),

                    Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => logOutDialog(),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF0000),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error.toString()}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChangeUsernameDialog extends StatelessWidget {
  final currUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _newUsernameController = TextEditingController();

  ChangeUsernameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user-details')
          .doc(currUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDetails = snapshot.data!.data() as Map<String, dynamic>;

          return Dialog(
            child: Container(
              width: 310,
              height: 170,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "New Username",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      hintText: userDetails['username'],
                      textController: _newUsernameController,
                      horzonPadding: 0,
                    ),
                    SizedBox(height: 10),
                    Row(
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
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: 51,
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error${snapshot.error.toString()}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ChangeThemeDialog extends StatelessWidget {
  final currUser = FirebaseAuth.instance.currentUser;

  ChangeThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 310,
        height: 240,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Theme", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              SizedBox(height: 10),

              Container(
                width: 277,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Light',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(),
                      Icon(Icons.radio_button_checked, size: 17),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              Container(
                width: 277,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(),
                      Icon(Icons.radio_button_off, size: 17),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
              Row(
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
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 125,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class logOutDialog extends StatelessWidget {
  final currUser = FirebaseAuth.instance.currentUser;

  logOutDialog({super.key});

  // Log Out Function
  void logOutFunction() {
    // log out
    final authServ = AuthService();
    authServ.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 310,
        height: 154,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Text(
                "Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.red,
                ),
              ),

              SizedBox(height: 10),

              Row(
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
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      logOutFunction();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 125,
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.green,
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
            ],
          ),
        ),
      ),
    );
  }
}
