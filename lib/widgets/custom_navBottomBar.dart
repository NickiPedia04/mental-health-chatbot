import 'package:flutter/material.dart';
import 'package:mental_app_support/pages/chat_page.dart';
import 'package:mental_app_support/pages/home_page.dart';
import 'package:mental_app_support/pages/settings_page.dart';

class CustomNavbottombar extends StatefulWidget {
  const CustomNavbottombar({super.key});

  @override
  State<CustomNavbottombar> createState() => _CustomNavbottombarState();
}

class _CustomNavbottombarState extends State<CustomNavbottombar> {
  // Page index
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [HomePage(), Chatpage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: customNavBar(context),
    );
  }

  Container customNavBar(BuildContext context) {
    return Container(
      height: 73,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Page
            IconButton(
              enableFeedback: false,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedPageIndex = 0;
                });
              },
              icon: _selectedPageIndex == 0
                  ? Icon(
                      Icons.home_sharp,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Icon(
                      Icons.home_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
            ),

            // Chat Page
            IconButton(
              enableFeedback: false,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedPageIndex = 1;
                });
              },
              icon: _selectedPageIndex == 1
                  ? Icon(
                      Icons.chat,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Icon(
                      Icons.chat_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
            ),

            // Settings Page
            IconButton(
              enableFeedback: false,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _selectedPageIndex = 2;
                });
              },
              icon: _selectedPageIndex == 2
                  ? Icon(
                      Icons.settings,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : Icon(
                      Icons.settings_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
