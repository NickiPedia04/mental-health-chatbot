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

  void _navBottomBar(int _nextPage) {
    setState(() {
      _selectedPageIndex = _nextPage;
    });
  }

  final List<Widget> _pages = [HomePage(), Chatpage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _navBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
