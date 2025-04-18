import 'dart:io';
import 'package:flutter/material.dart';
import 'package:happy_paw/page/Addmissingpet.dart';
import 'package:happy_paw/page/Addpet.dart';
import 'package:happy_paw/page/favorite.dart';
import '/model/auth_service.dart';
import '/model/user_database_helper.dart';
import '/page/detail.dart';
import '/page/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  int? userId;
  String username = '';
  String email = '';
  bool isLoading = true;
  String? profilePicturePath;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });

      final currentUser = await _authService.getLoggedInUser();

      if (currentUser != null) {
        setState(() {
          userId = currentUser.id;
          username = currentUser.username;
          email = currentUser.email;
          profilePicturePath = currentUser.profilePicture;
          isLoading = false;
        });
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile data')));
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName =
            'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = path.join(appDir.path, fileName);

        
        final File newImage = await File(pickedFile.path).copy(filePath);

        
        if (userId != null) {
          final success = await _authService.updateProfile(
            userId: userId!,
            profilePicture: filePath,
          );

          if (success) {
            setState(() {
              profilePicturePath = filePath;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Profile picture updated')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update profile picture')),
            );
          }
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image')));
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('เลือกจากแกลเลอรี่'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('ถ่ายภาพ'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    try {
      final result = await _authService.logout();
      if (result) {
        _navigateToLogin();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed')));
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Happy Paw', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.teal))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    image:
                                        profilePicturePath != null
                                            ? DecorationImage(
                                              image: FileImage(
                                                File(profilePicturePath!),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : DecorationImage(
                                              image: AssetImage(''),
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.teal,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF6D173),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFF6D173),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildMenuSection(),
                  ],
                ),
              ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          buildMenuButton(Icons.pets, 'Add new pet', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPetScreen()),
            );
          }),
          SizedBox(height: 10),
          buildMenuButton(Icons.report, 'Add missing pet', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMissingPetScreen()),
            );
          }),
          SizedBox(height: 10),
          buildMenuButton(Icons.favorite, 'Favorite', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritePage()),
            );
          }),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: _logout,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(IconData icon, String title, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.teal, fontSize: 16),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        ],
      ),
    );
  }
}
