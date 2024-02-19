import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:luxeride/screens/bookings.dart';
import 'package:luxeride/screens/home.dart';
import 'package:luxeride/screens/settings.dart';
import 'package:luxeride/screens/subscreens/add_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> pages = [
    const Home(),
    const AddScreen(),
    const Bookings(),
    const Profile()
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00f3f5f7),
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color.fromARGB(255, 249, 249, 249),
          color: Colors.black54,
          buttonBackgroundColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          index: currentIndex,
          onTap: onTap,
          items: const [
            Icon(Icons.home_filled, color: Colors.white),
            Icon(Icons.add, color: Colors.white),
            Icon(Icons.done_all_rounded, color: Colors.white),
            Icon(Icons.settings, color: Colors.white)
          ]),
    );
  }
}
