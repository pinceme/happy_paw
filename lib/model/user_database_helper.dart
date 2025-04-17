
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? fullName;
  final String? profilePicture;
  final String? phoneNumber;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.profilePicture,
    this.phoneNumber,
    this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      profilePicture: map['profilePicture'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }


  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? fullName,
    String? profilePicture,
    String? phoneNumber,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  static Database? _database;


  factory UserDatabaseHelper() => _instance;

  UserDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT,
        profilePicture TEXT,
        phoneNumber TEXT,
        address TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }


  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }


  Future<int> signUp(User user) async {
    try {
      final Database db = await database;

      
      final List<Map<String, dynamic>> usernameCheck = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [user.username],
      );

      if (usernameCheck.isNotEmpty) {
        throw Exception('Username already exists');
      }

      final List<Map<String, dynamic>> emailCheck = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email],
      );

      if (emailCheck.isNotEmpty) {
        throw Exception('Email already exists');
      }

      
      var userMap = user.toMap();
      userMap['password'] = _hashPassword(user.password);

      return await db.insert('users', userMap);
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  
  Future<User> login(String usernameOrEmail, String password) async {
    try {
      final Database db = await database;

      
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'username = ? OR email = ?',
        whereArgs: [usernameOrEmail, usernameOrEmail],
      );

      if (result.isEmpty) {
        throw Exception('User not found');
      }

      final Map<String, dynamic> userMap = result.first;
      final String storedPassword = userMap['password'];
      
      
      final String hashedPassword = _hashPassword(password);

      
      if (storedPassword != hashedPassword) {
        throw Exception('Invalid password');
      }

      return User.fromMap(userMap);
    } catch (e) {
      print('Login error in UserDatabaseHelper: $e');
      rethrow;
    }
  }

  
  Future<User?> getUserById(int? id) async {
    if (id == null) return null;
    
    final Database db = await database;
    
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }

  
  Future<int> updateUserProfile(User user) async {
    if (user.id == null) {
      throw Exception('User ID cannot be null for update');
    }
    
    final Database db = await database;

    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  
  Future<int> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    final Database db = await database;

    
    final user = await getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    
    if (user.password != _hashPassword(currentPassword)) {
      throw Exception('Current password is incorrect');
    }

    
    return await db.update(
      'users',
      {
        'password': _hashPassword(newPassword),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  
  Future<int> deleteUser(int userId) async {
    final Database db = await database;

    return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  
  Future<User?> getUserByUsername(String username) async {
    final Database db = await database;
    
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }
}