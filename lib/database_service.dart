import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Function to add a new user
  Future<void> addUser({
    required String userId,
    required String name,
    required String email,
    required String password,
    String role = 'user', // Default role as 'user'
  }) async {
    try {
      await _dbRef.child('users').child(userId).set({
        'user_id': userId,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
    } catch (e) {
      print('Error adding user: $e');
      throw e;
    }
  }

  // Function to add a new admin
  Future<void> addAdmin({
    required String adminId,
    required String userId, // This is a foreign key from user table
    required String packageId,
  }) async {
    try {
      await _dbRef.child('admins').child(adminId).set({
        'admin_id': adminId,
        'user_id': userId, // Reference to user table
        'package_id': packageId,
      });
    } catch (e) {
      print('Error adding admin: $e');
      throw e;
    }
  }
}
