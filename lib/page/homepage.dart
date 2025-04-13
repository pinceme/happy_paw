import 'dart:io';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'explore.dart';
import 'package:happy_paw/model/petdatabasehelper.dart';
import 'package:happy_paw/model/pet.dart';
import 'package:happy_paw/model/auth_service.dart';

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
  List<Pet> missingPets = [];
  bool isLoading = true;

  final AuthService _authService = AuthService();
  String username = '';
  String? profilePicturePath;
  bool isUserLoading = true;

  bool isSelectionMode = false;
  Set<int> selectedPetIds = {};

  void _addSamplePet() {
    final samplePet = Pet(
      name: 'Mimi',
      type: 'Cat',
      breed: 'Scottish Fold',
      gender: 'Female',
      age: '2 years',
      weight: '3.8 kg',
      location: 'Bangkok',
      about: 'หายจากบ้านเมื่อวันที่ 3 เม.ย. น้องใส่ปลอกคอชมพู',
      imagePath: 'assets/images/ex_cat.jpg',
      ownerName: 'คุณแป้ง',
      ownerMessage: '',
      contactChat: 'pang_lostcat',
      contactPhone: '091-111-2233',
    );

    setState(() {
      missingPets.insert(0, samplePet);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMissingPets();
    _loadUserData();
    _addSamplePet();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = await _authService.getLoggedInUser();
      if (currentUser != null) {
        setState(() {
          username = currentUser.username;
          profilePicturePath = currentUser.profilePicture;
          isUserLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isUserLoading = false;
      });
    }
  }

  Future<void> _loadMissingPets() async {
    final allPets = await DatabaseHelper.instance.getAllPets();
    setState(() {
      missingPets = allPets.where((pet) => pet.ownerMessage.isEmpty).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          isSelectionMode
              ? 'เลือก ${selectedPetIds.length} รายการ'
              : 'Happy Paw',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading:
            isSelectionMode
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSelectionMode = false;
                      selectedPetIds.clear();
                    });
                  },
                )
                : null,
        actions: [
          isSelectionMode
              ? IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'ลบที่เลือก',
                onPressed:
                    selectedPetIds.isEmpty
                        ? null
                        : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('ลบสัตว์ที่เลือก?'),
                                  content: Text(
                                    'คุณแน่ใจหรือไม่ว่าต้องการลบ ${selectedPetIds.length} รายการ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('ยืนยัน'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            for (final id in selectedPetIds) {
                              await DatabaseHelper.instance.deletePet(id);
                            }
                            selectedPetIds.clear();
                            setState(() {
                              isSelectionMode = false;
                            });
                            _loadMissingPets();
                          }
                        },
              )
              : IconButton(
                icon: const Icon(Icons.select_all),
                tooltip: 'เลือกเพื่อลบ',
                onPressed: () {
                  setState(() {
                    isSelectionMode = true;
                  });
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
                Text(
                  isUserLoading ? 'Hello, User 👋' : 'Hello, $username 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                isUserLoading
                    ? const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    )
                    : CircleAvatar(
                      backgroundImage:
                          profilePicturePath != null
                              ? FileImage(File(profilePicturePath!))
                              : const AssetImage('') as ImageProvider,
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
                  MaterialPageRoute(builder: (context) => const Explore()),
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
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isSelectionMode) {
                                  final id = pet.id;
                                  if (id != null) {
                                    setState(() {
                                      selectedPetIds.contains(id)
                                          ? selectedPetIds.remove(id)
                                          : selectedPetIds.add(id);
                                    });
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              PetDetailScreen(pet: pet),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                color:
                                    pet.ownerMessage.trim().isEmpty
                                        ? const Color.fromARGB(
                                          255,
                                          252,
                                          99,
                                          122,
                                        )
                                        : Colors.white,
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child:
                                          pet.imagePath.contains('assets/')
                                              ? Image.asset(
                                                pet.imagePath,
                                                height: 250,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.file(
                                                File(pet.imagePath),
                                                height: 250,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
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
                            ),
                            if (isSelectionMode && pet.id != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPetIds.contains(pet.id!)
                                          ? selectedPetIds.remove(pet.id!)
                                          : selectedPetIds.add(pet.id!);
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      selectedPetIds.contains(pet.id!)
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color:
                                          selectedPetIds.contains(pet.id!)
                                              ? Colors.teal
                                              : Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
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
