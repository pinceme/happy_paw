import 'package:flutter/material.dart';
import 'package:happy_paw/model/pet.dart';
import 'package:happy_paw/model/databasehelper.dart';
import 'package:happy_paw/page/detail.dart';
import 'package:happy_paw/page/addpet.dart';
import 'dart:io';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pet> pets = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      setState(() => isLoading = true);
      pets = await DatabaseHelper.instance.getAllPets();
      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading pets: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAllPets() async {
    await DatabaseHelper.instance.deleteAllPets();
    _loadPets();
  }

  void updatePet(Pet updatedPet) {
    setState(() {
      final index = pets.indexWhere((p) => p.id == updatedPet.id);
      if (index != -1) pets[index] = updatedPet;
    });
  }

  List<Pet> getFilteredPets() {
    if (searchQuery.isEmpty) return pets;
    return pets.where((pet) {
      final query = searchQuery.toLowerCase();
      return pet.name.toLowerCase().contains(query) ||
          pet.breed.toLowerCase().contains(query) ||
          pet.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPets = getFilteredPets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'ล้างข้อมูลทั้งหมด',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('ลบข้อมูลทั้งหมด?'),
                      content: const Text(
                        'คุณแน่ใจหรือไม่ว่าต้องการลบสัตว์เลี้ยงทั้งหมด?',
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
                await _deleteAllPets();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFEAB816),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredPets.isEmpty
                    ? const Center(child: Text('ไม่พบสัตว์เลี้ยงที่ค้นหา'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        return PetCard(
                          pet: filteredPets[index],
                          onPetUpdated: updatePet,
                          onReturn: _loadPets,
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetScreen()),
          );
          if (result == true) {
            _loadPets();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onPetUpdated;
  final Function() onReturn;

  const PetCard({
    Key? key,
    required this.pet,
    required this.onPetUpdated,
    required this.onReturn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedPet = await Navigator.push<Pet>(
          context,
          MaterialPageRoute(builder: (context) => PetDetailScreen(pet: pet)),
        );

        if (updatedPet != null) {
          onPetUpdated(updatedPet);
        } else {
          onReturn();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
                child: _buildPetImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pet.name} (${pet.breed})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        pet.gender.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        color:
                            pet.gender.toLowerCase() == 'male'
                                ? Colors.blue
                                : Colors.pink,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pet.location,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTag(pet.age, Colors.teal, Colors.white),
                      const SizedBox(width: 4),
                      _buildTag(
                        pet.weight,
                        const Color(0xFFEAB816),
                        Colors.black,
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
  }

  Widget _buildPetImage() {
    if (pet.imagePath.isNotEmpty) {
      final file = File(pet.imagePath);
      return file.existsSync()
          ? Image.file(file, fit: BoxFit.cover, width: double.infinity)
          : _placeholder();
    } else {
      return _placeholder();
    }
  }

  Widget _placeholder() {
    return Image.asset(
      'assets/images/pet_placeholder.png',
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.pets, color: Colors.grey)),
        );
      },
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 10)),
    );
  }
}
