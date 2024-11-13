import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travenour_app/home.dart';

class BookingScreen extends StatefulWidget {
  final String userId; // Add the userId parameter

  const BookingScreen({super.key, required this.userId}); // Initialize userId

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final DatabaseReference _bookingsRef = FirebaseDatabase.instance.ref().child('bookings');
  final DatabaseReference _packagesRef = FirebaseDatabase.instance.ref().child('packages');
  List<Map<String, dynamic>> bookings = []; // Store multiple bookings

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  Future<void> _fetchBookingDetails() async {
    final snapshot = await _bookingsRef.orderByChild('user_id').equalTo(widget.userId).get();
    if (snapshot.exists) {
      List<Map<String, dynamic>> fetchedBookings = [];
      for (var bookingEntry in snapshot.children) {
        final bookingData = bookingEntry.value as Map<dynamic, dynamic>;

        // Fetch package name using package_id
        final packageId = bookingData['package_id'];
        final packageSnapshot = await _packagesRef.child(packageId).get();
        final packageName = packageSnapshot.child('package_name').value;

        fetchedBookings.add({
          'booking_date': bookingData['booking_date'] ?? '',
          'amount': bookingData['amount'] ?? '',
          'package_name': packageName ?? '',
        });
      }
      setState(() {
        bookings = fetchedBookings; // Update the state with the list of bookings
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: bookings.map((booking) {
                    return Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Date: ${booking['booking_date']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Package: ${booking['package_name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amount: ${booking['amount']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
