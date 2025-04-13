import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:happy_paw/model/pet.dart';
import 'package:happy_paw/model/auth_service.dart';
import 'favorite_list.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final AuthService _authService = AuthService();
  String username = '';
  String? profilePicturePath;
  bool isUserLoading = true;

  String? dogFact;
  bool isFactLoading = false;

  String? catFact;
  bool isCatFactLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchDogFact();
    fetchCatFact();
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

  Future<void> fetchDogFact() async {
    setState(() => isFactLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://dogapi.dog/api/v1/facts?number=1'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dogFact = data['facts'][0];
          isFactLoading = false;
        });
      } else {
        setState(() {
          dogFact = 'ไม่สามารถโหลดข้อมูลได้';
          isFactLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        dogFact = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
        isFactLoading = false;
      });
    }
  }

  Future<void> fetchCatFact() async {
    setState(() => isCatFactLoading = true);
    try {
      final response = await http.get(Uri.parse('https://catfact.ninja/fact'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          catFact = data['fact'];
          isCatFactLoading = false;
        });
      } else {
        setState(() {
          catFact = 'ไม่สามารถโหลดข้อมูลแมวได้';
          isCatFactLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        catFact = 'เกิดข้อผิดพลาดในการโหลดข้อมูลแมว';
        isCatFactLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMissing = widget.pet.ownerMessage.trim().isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isMissing ? Colors.redAccent : Colors.teal,
        title: Text(
          isMissing ? 'สัตว์เลี้ยงหาย' : 'รายละเอียดสัตว์เลี้ยง',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  widget.pet.imagePath.contains('assets/')
                      ? Image.asset(
                        widget.pet.imagePath,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.file(
                        File(widget.pet.imagePath),
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 100,
                          );
                        },
                      ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.pet.breed,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                FavoriteButton(pet: widget.pet),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isMissing ? Colors.red : Colors.teal,
                ),
                const SizedBox(width: 6),
                Text(widget.pet.location),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _infoTag(widget.pet.age, isMissing),
                _infoTag(widget.pet.gender, isMissing),
                _infoTag('${widget.pet.weight} kg', isMissing),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.pet.about.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ข้อมูลเพิ่มเติม',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.pet.about),
                ],
              ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color:
                    isMissing
                        ? const Color(0xFFFFCDD2)
                        : const Color(0xFFB2DFDB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isMissing
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF00796B),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isUserLoading
                      ? const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                      : CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            profilePicturePath != null
                                ? FileImage(File(profilePicturePath!))
                                : const AssetImage(
                                      'assets/images/default_profile.png',
                                    )
                                    as ImageProvider,
                      ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUserLoading ? widget.pet.ownerName : username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Line ID: ${widget.pet.contactChat}'),
                        Text('Phone: ${widget.pet.contactPhone}'),
                        const SizedBox(height: 10),
                        if (!isMissing && widget.pet.ownerMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.pet.ownerMessage,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (widget.pet.type.toLowerCase() == 'dog') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets, color: Colors.brown),
                        SizedBox(width: 8),
                        Text(
                          'Did you know? 🐶',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isFactLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                          dogFact ?? 'ไม่มีข้อมูล',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                  ],
                ),
              ),
            ],
            if (widget.pet.type.toLowerCase() == 'cat') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets, color: Colors.purple),
                        SizedBox(width: 8),
                        Text(
                          'Did you know? 🐱',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    isCatFactLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                          catFact ?? 'ไม่มีข้อมูล',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoTag(String text, bool isMissing) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isMissing
                ? Colors.redAccent.withOpacity(0.1)
                : Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final Pet pet;
  const FavoriteButton({super.key, required this.pet});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool get isFavorite => favoritePets.any((p) => p.name == widget.pet.name);

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoritePets.removeWhere((p) => p.name == widget.pet.name);
      } else {
        favoritePets.add(widget.pet);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'นำออกจากรายการโปรดแล้ว' : 'เพิ่มในรายการโปรดแล้ว',
        ),
        backgroundColor: isFavorite ? Colors.grey : Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: toggleFavorite,
    );
  }
}
