import 'package:flutter/material.dart';
import 'page/signup.dart';

// import 'package:happy_paw/buttomnav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(), // เปลี่ยนเป็นหน้าที่ต้องการแสดง
    );
  }
}
