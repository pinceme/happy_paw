import 'package:flutter/material.dart';
import 'page/signup.dart';

// import 'package:happy_paw/buttomnav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  // @override
  // State<MyApp> createState() => _MyAppState();
// }

// // class _MyAppState extends State<MyApp> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
// //   }
// // }

// class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(), // เปลี่ยนเป็นหน้าที่ต้องการแสดง
    );
  }
}
