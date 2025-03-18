import 'package:flutter/material.dart';
import 'page/homepage.dart';
import 'page/explore.dart';

class Buttomnav extends StatefulWidget {
  const Buttomnav({super.key});

  @override
  State<Buttomnav> createState() => _Buttomnav();
}

class _Buttomnav extends State<Buttomnav> {
  int current_page = 0;
  List page = [Homepage(), Explore()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEAB816),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        currentIndex: current_page,
        onTap: (index) {
          setState(() {
            current_page = index; // อัปเดตหน้าที่เลือก
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
