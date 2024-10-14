import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  // Reference to the Firebase Realtime Database
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Method to add a user
  Future<void> addUser(String userId, String userName, String email, String password) async {
    await _dbRef.child("users/$userId").set({
      "user_id": userId,
      "user_name": userName,
      "email": email,
      "password": password,  // Store hashed password
      "role": "user"
    });
  }

  // // Method to add an admin
  // Future<void> addAdmin(String adminId, String packageId, String userId) async {
  //   await _dbRef.child("admins/$adminId").set({
  //     "admin_id": adminId,
  //     "package_id": packageId,
  //     "user_id": userId,
  //     "role": "admin"
  //   });
  // }
}
