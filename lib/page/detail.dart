import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PetDetailScreen(),
    );
  }
}

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Happy Paw ', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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

            // ชื่อและสายพันธุ์
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
                      TextSpan(text: "Dobber "), // ชื่อหมา
                      TextSpan(
                        text: "(Labrador)", // สายพันธุ์
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
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                SizedBox(width: 4),
                Text("Nakornpathom"),
              ],
            ),
            const SizedBox(height: 12),

            // ข้อมูลแท็ก (อายุ เพศ น้ำหนัก)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "5 month",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Male",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // เพิ่มระยะห่างระหว่างบรรทัด
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB816),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "2 kg",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ข้อมูลเจ้าของ
            Container(
              decoration: BoxDecoration(
                color:
                    Colors
                        .teal, // เปลี่ยนพื้นหลังของ Card เป็นสีเขียว// สีพื้นหลังของ Container
                borderRadius: BorderRadius.circular(12), // ทำให้ขอบมน
              ),
              child: Card(
                elevation: 3,
                color: const Color.fromARGB(0, 255, 255, 255),
                shadowColor: Colors.transparent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ข้อมูลเจ้าของ
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start, // จัดให้อวาตาร์กับข้อความอยู่ด้านบน
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
                                    color: Color.fromARGB(
                                      255,
                                      245,
                                      243,
                                      134,
                                    ), // สีตัวอักษร
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFEAB816,
                                    ), // พื้นหลังสีเหลือง
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.2,
                                        ), // เงาสีดำจาง ๆ
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 234, 226, 191),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.chat,
                                    color: Colors.blue,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "DragonG",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 234, 226, 191),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "093-123-1234",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
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
