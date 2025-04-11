import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'detail.dart';
import 'explore.dart';
import 'package:happy_paw/model/petdatabasehelper.dart';
import 'package:happy_paw/model/pet.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  get pet => null;
  List<Pet> missingPets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissingPets();
  }

  Future<void> _loadMissingPets() async {
    final allPets = await DatabaseHelper.instance.getAllPets();
    setState(() {
      missingPets = allPets.where((pet) => pet.ownerMessage.isEmpty).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteMissingPets() async {
    final allPets = await DatabaseHelper.instance.getAllPets();
    final missing = allPets.where((pet) => pet.ownerMessage.isEmpty).toList();
    for (final pet in missing) {
      if (pet.id != null) {
        await DatabaseHelper.instance.deletePet(pet.id!);
      }
    }
    _loadMissingPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'ลบข้อมูลสัตว์หายทั้งหมด',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('ลบสัตว์หายทั้งหมด?'),
                      content: const Text(
                        'คุณแน่ใจหรือไม่ว่าต้องการลบสัตว์หายทั้งหมด?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('ยกเลิก'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('ยืนยัน'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await _deleteMissingPets();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://www.example.com/profile.jpg',
                  ),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Explore()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _categoryIcon('assets/icons/dog.png', Colors.teal),
                  _categoryIcon('assets/icons/cat.png', Colors.amber),
                  _categoryIcon('assets/icons/rabbits.png', Colors.teal),
                  _categoryIcon('assets/icons/raven.png', Colors.amber),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'สัตว์เลี้ยงที่หายไป',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : missingPets.isEmpty
                ? const Text('ไม่พบข้อมูลสัตว์เลี้ยงที่หาย')
                : Column(
                  children:
                      missingPets.map((pet) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetDetailScreen(pet: pet),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(pet.imagePath),
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pet.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            pet.location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetDetailScreen(pet: pet),
                  ),
                );
              },
              child: Card(
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error loading image');
                        },
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
        borderRadius: BorderRadius.circular(15),
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
