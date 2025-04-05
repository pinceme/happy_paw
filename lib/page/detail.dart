import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PetDetailScreen(),
    );
  }
}

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  String? dogFact;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDogFact();
  }

  Future<void> fetchDogFact() async {
    final url = Uri.parse('https://dogapi.dog/api/v1/facts?number=150');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['facts'] != null && data['facts'].isNotEmpty) {
          setState(() {
            dogFact = data['facts'][0];
            isLoading = false;
          });
        } else {
          setState(() {
            dogFact = "No dog facts available.";
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load fact');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dogFact = "Unable to load dog fact.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐶 รูปภาพ
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/dogd1.png",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // ชื่อและสายพันธุ์ + ปุ่ม Favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Dobber "),
                      TextSpan(
                        text: "(Labrador)",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 175, 139, 38),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const FavoriteButton(),
              ],
            ),

            // สถานที่
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                SizedBox(width: 4),
                Text("Nakornpathom"),
              ],
            ),
            const SizedBox(height: 12),

            // ข้อมูลแท็ก
            Wrap(
              spacing: 8,
              children: [
                _tag("5 month", Colors.teal, Colors.white),
                _tag("Male", Colors.teal, Colors.white),
                _tag("2 kg", const Color(0xFFEAB816), Colors.black),
              ],
            ),
            const SizedBox(height: 20),

            // กล่องข้อมูลเจ้าของ
            Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Card(
                elevation: 3,
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // เจ้าของ + ข้อความ
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/profile.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Wisswaprint London",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 245, 243, 134),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAB816),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "สวัสดีครับผมชื่อเขียว เจอสุนัขตัวนี้หลงอยู่แถวบ้าน ผมดูแลให้อาหาร อาบน้ำ และพาไปฉีดยาเรียบร้อย แต่ตอนนี้ผมมีสุนัขอยู่แล้ว 6 ตัว เลยคิดว่าอาจจะดูแลต่อไม่ไหว ผมจึงอยากให้เขาได้บ้านใหม่ที่พร้อมกว่าผม ถ้าใครสนใจโปรดติดต่อผมได้ครับ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _contactBox(Icons.chat, "DragonG", Colors.blue),
                          const SizedBox(width: 8),
                          _contactBox(
                            Icons.phone,
                            "093-123-1234",
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🐾 DOG FACT ด้านล่างสุด
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (dogFact != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dogFact!,
                        style: const TextStyle(fontSize: 14),
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

  Widget _tag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: textColor)),
    );
  }

  Widget _contactBox(IconData icon, String text, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 234, 226, 191),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 12),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
