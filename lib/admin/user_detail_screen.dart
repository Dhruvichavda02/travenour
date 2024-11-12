import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final DatabaseReference _bookingsRef = FirebaseDatabase.instance.ref().child('bookings');
  final DatabaseReference _packagesRef = FirebaseDatabase.instance.ref().child('packages');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');

  // Method to fetch booking details
  Future<List<Map<String, dynamic>>> fetchBookingDetails() async {
    DataSnapshot snapshot = await _bookingsRef.get();
    List<Map<String, dynamic>> bookingDetails = [];

    for (var booking in snapshot.children) {
      String packageId = booking.child('package_id').value.toString();
      String userId = booking.child('user_id').value.toString();
      String bookingDate = booking.child('booking_date').value.toString();

      // Fetch package name
      DataSnapshot packageSnapshot = await _packagesRef.child(packageId).get();
      String packageName = packageSnapshot.child('package_name').value.toString();

      // Fetch username
      DataSnapshot userSnapshot = await _usersRef.child(userId).get();
      String username = userSnapshot.child('username').value.toString();

      bookingDetails.add({
        'package_id': packageId,
        'package_name': packageName,
        'username': username,
        'booking_date': bookingDate,
      });
    }
    return bookingDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Roles')),
      
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: fetchBookingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          List<Map<String, dynamic>> bookingDetails = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Package Id')),
                  DataColumn(label: Text('Package Name')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Booking Date')),
                ],
                rows: bookingDetails.map((booking) {
                  return DataRow(cells: [
                    DataCell(Text(booking['package_id'])),  // Use DataCell for data
                    DataCell(Text(booking['package_name'])),
                    DataCell(Text(booking['username'])),
                    DataCell(Text(booking['booking_date'])),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
