import 'package:flutter/material.dart';

class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  int _currentIndex = 0; // ตัวแปรเก็บ index ของหน้า

  final List<Widget> _page = [
    Center(child: Text("homepage")), // เปลี่ยนเป็นหน้าอื่นที่ต้องการ
    Center(child: Text("Explore")),
    Center(child: Text("Donate")),
    Center(child: Text("Profile")),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Donation",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Your donation makes a world of difference for our furry friends",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  donationCard(
                    title: "มูลนิธิบ้านสงเคราะห์สัตว์พิการ (home4animals)",
                    description:
                        "เป็นศูนย์เลี้ยงดูสัตว์พิการที่รับอุปการะสัตว์ที่ต้องการความช่วยเหลือให้มีชีวิตที่ดีขึ้น",
                    contact:
                        "ข้อมูลการติดต่อ\n 📞 02-5844896, 02-961-5360\n📍 เลขที่ 151/1 ม.1 ต.บ้านใหม่ อ.ปากเกร็ด จ.นนทบุรี 11120",
                    qrImage: "assets/images/qr1.png",
                    imagePath: "assets/images/donate1.png",
                    
                    color: const Color.fromARGB(255, 229, 205, 169)!,
                  ),
                  const SizedBox(height: 16),
                  donationCard(
                    title: "ป้าจิ๋ว บ้านพักสี่เท้าเพื่อหมาจร",
                    description:
                        "ศูนย์พักพิงสำหรับสุนัขที่ถูกทอดทิ้ง ช่วยเหลือและรักษาสุนัขจรจัดที่ต้องการบ้านใหม่",

                    contact: "ข้อมูลการติดต่อ\n 📞 086 775 1151\n📍 เลขที่ 27/2 ม.4 จ.ปทุมธานี",
                    qrImage: "assets/images/qr2.png",
                    imagePath: "assets/images/donate2.png",
                    color: const Color.fromARGB(255, 229, 205, 169)!,
                  ),
                  const SizedBox(height: 16),
                  donationCard(
                    title: "เกาะสุนัข (พุทธมณฑล)",
                    description:
                        "สถานที่สำหรับพักพิงสุนัขจรจัด ที่ประชาชนบางส่วน ลักลอบนำสุนัขมาปล่อย เกิดการแพร่พันธุ์เพิ่มเป็นจำนวนมาก พุทธมณฑลได้มองเห็นถึงปัญหาสุนัขจรจัดภายในพุทธมณฑล",
                        
                    contact: "ข้อมูลการติดต่อ\n📞 081 831 6632\n📍 เกาะสุนัข (พุทธมณฑล) : ต.ศาลายา อ.พุทธมณฑล จ.นครปฐม 73170",
                    qrImage: "assets/images/qr3.png",
                    imagePath: "assets/images/donate3.png",
                    color: const Color.fromARGB(255, 229, 205, 169)!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // อัปเดตหน้าที่เลือก
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget donationCard({
    required String title,
    required String description,
    required String contact,
    required String qrImage,
    required String imagePath,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(contact, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(qrImage, width: 50, height: 50),
          ),
        ],
      ),
    );
  }
}
