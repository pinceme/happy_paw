import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // Remove BottomNavigationBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Wisswaprint London',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 510, // จำกัดความสูงสูงสุด
                ),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 90,
                      child: buildMenuButton(
                        Icons.add,
                        'Add new pet',
                      ), // Custom size for this button
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 90,
                      child: buildMenuButton(Icons.add, 'Add missing pet'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 90,
                      child: buildMenuButton(Icons.favorite, 'Add missing pet'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 90,
                      child: buildMenuButton(Icons.account_circle, 'Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
