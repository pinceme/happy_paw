import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Hello, Mark 👋',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://www.example.com/profile.jpg',
                  ), // เปลี่ยนเป็น URL จริง
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('What are you looking for today?'),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFEAB816),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ แก้จาก child เป็น children แล้วเพิ่ม Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _categoryIcon('assets/icons/dog.png', Colors.teal),
                _categoryIcon('assets/icons/cat.png', Colors.amber),
                _categoryIcon(
                  'assets/icons/rabbits.png',
                  Colors.teal,
                ), // ✅ เปลี่ยนจาก rabbits.png
                _categoryIcon(
                  'assets/icons/raven.png',
                  Colors.amber,
                ), // ✅ เปลี่ยนจาก raven.png
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Missing pets',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/cat.jpg',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Berito',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.male, color: Colors.red),
                            SizedBox(width: 5),
                            Text('Nakornpathom (Current location)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryIcon(String imagePath, Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15), // ทำให้มุมมน
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
