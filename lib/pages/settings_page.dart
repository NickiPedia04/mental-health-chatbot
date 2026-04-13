import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/auth/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final currUser = FirebaseAuth.instance.currentUser;

  // Log Out Function
  void logOutFunction() {
    // log out
    final authServ = AuthService();
    authServ.signOut();
  }

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
                          Container(
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

                          SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                'Preferences',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
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
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: logOutFunction,
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
