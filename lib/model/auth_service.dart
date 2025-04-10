// auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'user_database_helper.dart';

class AuthService {
  final UserDatabaseHelper _dbHelper = UserDatabaseHelper();

  // เก็บ session ของผู้ใช้ที่ login
  Future<bool> saveUserSession(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt('userId', userId);
    } catch (e) {
      print('Error saving user session: $e');
      return false;
    }
  }

  // ตรวจสอบว่ามีผู้ใช้ที่ login อยู่หรือไม่
  Future<int?> getLoggedInUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('userId');
    } catch (e) {
      print('Error getting logged in user ID: $e');
      return null;
    }
  }

  // ดึงข้อมูลผู้ใช้ที่ login อยู่
  Future<User?> getLoggedInUser() async {
    try {
      final userId = await getLoggedInUserId();
      if (userId == null) {
        print('No logged in user found');
        return null;
      }
      return await _dbHelper.getUserById(userId);
    } catch (e) {
      print('Error getting logged in user: $e');
      return null;
    }
  }

  // ลงทะเบียนผู้ใช้ใหม่
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final user = User(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      final userId = await _dbHelper.signUp(user);
      return userId > 0;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // เข้าสู่ระบบ
  Future<User?> login(String usernameOrEmail, String password) async {
    try {
      final user = await _dbHelper.login(usernameOrEmail, password);
      if (user.id != null) {
        print('Login successful for user: ${user.username}');
        final saved = await saveUserSession(user.id!);
        if (!saved) {
          print('Warning: Failed to save user session');
        }
        return user;
      } else {
        print('Login failed: User ID is null');
        throw Exception('User ID is null after login');
      }
    } catch (e) {
      print('Login error in AuthService: $e');
      rethrow;
    }
  }

  // ออกจากระบบ
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('userId');
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  // อัปเดตโปรไฟล์
  Future<bool> updateProfile({
    required int userId,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? profilePicture,
  }) async {
    try {
      final user = await _dbHelper.getUserById(userId);
      if (user == null) {
        return false;
      }
      final updatedUser = user.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
        profilePicture: profilePicture,
      );
      final result = await _dbHelper.updateUserProfile(updatedUser);
      return result > 0;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // เปลี่ยนรหัสผ่าน
  Future<bool> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final result = await _dbHelper.changePassword(
        userId,
        currentPassword,
        newPassword,
      );
      return result > 0;
    } catch (e) {
      print('Change password error: $e');
      rethrow;
    }
  }

  // ลบเมธอดที่ไม่ได้ใช้งาน
  // userId() {} - ลบออกเนื่องจากไม่ได้ใช้งาน
}