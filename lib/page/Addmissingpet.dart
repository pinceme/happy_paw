// Add Missing Pet Page
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:happy_paw/model/petdatabasehelper.dart';
import 'package:happy_paw/model/pet.dart';

class AddMissingPetScreen extends StatefulWidget {
  const AddMissingPetScreen({super.key});

  @override
  State<AddMissingPetScreen> createState() => _AddMissingPetScreenState();
}

class _AddMissingPetScreenState extends State<AddMissingPetScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactChatController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();

  String? _selectedPetType;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String> _saveImage(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'pet_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.jpg';
    final savedImage = await image.copy('${appDir.path}/$fileName');
    return savedImage.path;
  }

  Pet _buildPet(String imagePath) {
    return Pet(
      name: _nameController.text,
      type: _selectedPetType ?? 'Dog',
      breed: _breedController.text,
      gender: _genderController.text,
      age: _ageController.text,
      weight: _weightController.text,
      location: _locationController.text,
      about: _aboutController.text,
      imagePath: imagePath,
      ownerName: _ownerNameController.text,
      ownerMessage: '', // missing pet => no message
      contactChat: _contactChatController.text,
      contactPhone: _contactPhoneController.text,
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบและเลือกรูปภาพ')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imagePath = await _saveImage(_image!);
      final pet = _buildPet(imagePath);
      await DatabaseHelper.instance.insertPet(pet);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดขณะบันทึกข้อมูล: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แจ้งสัตว์เลี้ยงหาย',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Missing Pet',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          _image != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                              : const Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.black,
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Pet Name*',
                  controller: _nameController,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pet Type*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  value: _selectedPetType,
                  items:
                      ['Dog', 'Cat', 'Rabbit', 'Bird']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => _selectedPetType = value),
                  validator:
                      (value) =>
                          value == null ? 'Please select a pet type' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Breeds*',
                        controller: _breedController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Gender*',
                        controller: _genderController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Age*',
                        controller: _ageController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Weight*',
                        controller: _weightController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Current location*',
                  controller: _locationController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'About Pet (Personality, Special Needs, etc.)',
                  controller: _aboutController,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Owner Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Line ID',
                        controller: _contactChatController,
                        icon: Icons.chat,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Phone Number',
                        controller: _contactPhoneController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submitForm,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: icon != null ? Icon(icon) : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
        validator: (value) {
          if (label.contains('*') && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _ownerNameController.dispose();
    _contactChatController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }
}
