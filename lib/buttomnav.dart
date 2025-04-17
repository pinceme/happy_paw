import 'package:flutter/material.dart';
import 'page/homepage.dart';
import 'page/explore.dart';
import 'page/donation.dart';
import 'page/profile.dart';

class Buttomnav extends StatefulWidget {
  const Buttomnav({super.key});

  @override
  State<Buttomnav> createState() => _Buttomnav();
}

class _Buttomnav extends State<Buttomnav> {
  int current_page = 0;
  List page = [Homepage(), Explore(), Donation(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEAB816),

        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        currentIndex: current_page,
        onTap: (index) {
          setState(() {
            current_page = index; 
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: page[current_page],
    );
  }
}
