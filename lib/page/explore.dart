import 'package:flutter/material.dart';
import 'package:happy_paw/model/pet.dart';
import 'package:happy_paw/model/petdatabasehelper.dart';
import 'package:happy_paw/page/detail.dart';
import 'package:happy_paw/page/addpet.dart';
import 'dart:io';

class Explore extends StatefulWidget {
  const Explore({super.key});

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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pet> pets = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedType = 'All';
  bool isSelectionMode = false;
  Set<int> selectedPetIds = {};

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

  void toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedPetIds.clear();
    });
  }

  void togglePetSelection(int id) {
    setState(() {
      if (selectedPetIds.contains(id)) {
        selectedPetIds.remove(id);
      } else {
        selectedPetIds.add(id);
      }
    });
  }

  Future<void> deleteSelectedPets() async {
    for (var id in selectedPetIds) {
      await DatabaseHelper.instance.deletePet(id);
    }
    toggleSelectionMode();
    _loadPets();
  }

  void updatePet(Pet updatedPet) {
    setState(() {
      final index = pets.indexWhere((p) => p.id == updatedPet.id);
      if (index != -1) pets[index] = updatedPet;
    });
  }

  List<Pet> getFilteredPets() {
    return pets.where((pet) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = pet.breed.toLowerCase().contains(query);
      final matchesType = selectedType == 'All' || pet.type == selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPets = getFilteredPets();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelectionMode
              ? 'เลือก ${selectedPetIds.length} รายการ'
              : 'Happy Paw',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading:
            isSelectionMode
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: toggleSelectionMode,
                )
                : null,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'ลบรายการที่เลือก',
              onPressed:
                  selectedPetIds.isEmpty
                      ? null
                      : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('ยืนยันการลบ'),
                                content: Text(
                                  'ลบสัตว์ ${selectedPetIds.length} ตัวหรือไม่?',
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
                                    child: const Text('ลบ'),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          await deleteSelectedPets();
                        }
                      },
            )
          else
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: 'เลือกเพื่อลบ',
              onPressed: toggleSelectionMode,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTypeFilter('All', Icons.pets, Colors.grey),
                  _buildTypeFilter('Dog', Icons.pets, Colors.teal),
                  _buildTypeFilter('Cat', Icons.pets, Colors.amber),
                  _buildTypeFilter('Rabbit', Icons.pets, Colors.green),
                  _buildTypeFilter('Bird', Icons.pets, Colors.orange),
                ],
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
                          isSelectable: isSelectionMode,
                          isSelected: selectedPetIds.contains(
                            filteredPets[index].id,
                          ),
                          onToggleSelected: togglePetSelection,
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
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypeFilter(String type, IconData icon, Color color) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onPetUpdated;
  final Function() onReturn;
  final bool isSelectable;
  final bool isSelected;
  final Function(int) onToggleSelected;

  const PetCard({
    super.key,
    required this.pet,
    required this.onPetUpdated,
    required this.onReturn,
    required this.isSelectable,
    required this.isSelected,
    required this.onToggleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final updatedPet = await Navigator.push<Pet>(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetailScreen(pet: pet),
              ),
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
            color:
                pet.ownerMessage.trim().isEmpty
                    ? const Color.fromARGB(255, 252, 99, 122)
                    : Colors.white,
            shadowColor:
                pet.ownerMessage.trim().isEmpty
                    ? const Color.fromARGB(255, 243, 29, 29)
                    : Colors.black12,
            elevation: pet.ownerMessage.trim().isEmpty ? 6 : 2,
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
        ),
        if (isSelectable)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => onToggleSelected(pet.id!),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.teal : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
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
