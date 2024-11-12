import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  File? imageFile, // Keep this if you need to upload the image directly
  String? imageUrl, // Add this parameter
}) async {
  try {
    String packageId = _dbRef.child('packages').push().key!;

    // If `imageFile` is provided, upload it and set `imageUrl`
    if (imageFile != null && imageUrl == null) {
      final storageRef = FirebaseStorage.instance.ref().child('package_images/$packageId');
      await storageRef.putFile(imageFile).then((taskSnapshot) async {
        imageUrl = await taskSnapshot.ref.getDownloadURL();
        print("Image uploaded. URL: $imageUrl");
      }).catchError((e) {
        print("Error uploading image: $e");
        throw e;
      });
    }

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
      'imageurl': imageUrl, // Store the image URL
    };

    await _dbRef.child('packages').child(packageId).set(packageData);
    print("Package added successfully.");
  } catch (e) {
    print('Error adding package: $e');
    throw e;
  }
}


   Future<void> addBooking({
  required String bookingId,
  required String userId,  // Foreign key from user table
  required String packageId, // Foreign key from package table
  required int numberOfPeople,
  required String bookingDate,
  required String amount,  // Amount (e.g., price * number of people)
  required String paymentType,
  required String paymentStatus,
}) async {
  try {
    // Creating a booking entry in the 'bookings' node
    await _dbRef.child('bookings').child(bookingId).set({
      'booking_id': bookingId, // Unique booking ID
      'user_id': userId, // Reference to the user who booked
      'package_id': packageId, // Reference to the booked package
      'no_of_people': numberOfPeople, // Number of people for the booking
      'booking_date': bookingDate, // Booking date
      'amount': amount, // Total amount (calculated as price * no_of_people)
      'payment_type': paymentType, // Type of payment (e.g., Credit Card, PayPal)
      'payment_status': paymentStatus, // Status of the payment (e.g., Paid, Pending)
    });
  } catch (e) {
    print('Error adding booking: $e');
    throw e;
  }
}

  
}
