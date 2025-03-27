import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:tasheha_app/pages/account_screen.dart';
import 'package:tasheha_app/pages/favorite.dart';
import 'package:tasheha_app/pages/chatting.dart';
import 'package:tasheha_app/pages/home.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Favorite(),
    Chatting(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomAppBar(
        color: AppColors.blueC,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: _selectedIndex == 1 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40), 
            IconButton(
              icon: Icon(Icons.chat, color: _selectedIndex == 2 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      
    );
  }
}
