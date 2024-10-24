import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Expose _dbRef as a getter to be used externally if needed
  DatabaseReference get dbRef => _dbRef;

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

  Future<void> addCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    try {
      await _dbRef.child('categories').child(categoryId).set({
        'category_id': categoryId,
        'category_name': categoryName,
      });
    } catch (e) {
      print('Error adding category: $e');
      throw e;
    }
  }

  // Function to get category ID by name
  Future<String?> getCategoryId(String categoryName) async {
    final snapshot = await _dbRef.child('categories').orderByChild('category_name').equalTo(categoryName).once();
    if (snapshot.snapshot.exists) {
      final categories = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return categories.keys.first.toString(); // Return the first matching category ID
    }
    return null;
  }

  // Function to add a new package
  Future<void> addPackage({
    required String packageName,
    required String description,
    required String categoryId,
    required double price,
    required List<String> facilities,
    required String startDate,
    required String endDate,
    required int totalDays,
    required int seatLimit,
    File? imageFile,
  }) async {
    try {
      String packageId = _dbRef.child('packages').push().key!;

      final packageData = {
        'package_id': packageId,
        'package_name': packageName,
        'description': description,
        'category_id': categoryId,
        'price': price,
        'facilities': facilities,
        'start_date': startDate,
        'end_date': endDate,
        'total_days': totalDays,
        'seat_limit': seatLimit,
      };

      await _dbRef.child('packages').child(packageId).set(packageData);
    } catch (e) {
      print('Error adding package: $e');
      throw e;
    }
  }

   Future<List<Map<String, dynamic>>> getPackagesByCategory(String categoryId) async {
    List<Map<String, dynamic>> packages = [];
    DataSnapshot snapshot = await dbRef.child('packages').orderByChild('categoryId').equalTo(categoryId).get();
    if (snapshot.value != null) {
      Map<dynamic, dynamic> packageMap = snapshot.value as Map<dynamic, dynamic>;
      packageMap.forEach((key, value) {
        packages.add(Map<String, dynamic>.from(value));
      });
    }
    return packages;

  }

   // Function to add a booking
  Future<void> addBooking({
    required String bookingId,
    required String userId,  // Foreign key from user table
    required String packageId, // Foreign key from package table
    required int numberOfPeople,
    required String bookingDate,
    String amount = 'Paid',  // Default amount set to 'Paid'
    required String paymentDate,
    required String paymentType,
    required String paymentStatus,
  }) async {
    try {
      await _dbRef.child('bookings').child(bookingId).set({
        'booking_id': bookingId,
        'user_id': userId,
        'package_id': packageId,
        'no_of_people': numberOfPeople,
        'booking_date': bookingDate,
        'amount': amount,
        'payment_date': paymentDate,
        'payment_type': paymentType,
        'payment_status': paymentStatus,
      });
    } catch (e) {
      print('Error adding booking: $e');
      throw e;
    }
  }
}
