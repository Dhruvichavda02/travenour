import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travenour_app/admin/add_admin.dart';

import 'admin_dashboard.dart';
import 'payment_status_screen.dart';
import 'pg_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingDetailsScreen(),
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final DatabaseReference _bookingsRef = FirebaseDatabase.instance.ref().child('bookings');
  final List<Map<String, dynamic>> bookings = [];
  
  int _currentIndex = 2; // Default to the "Booking" tab (index 2)

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() async {
    _bookingsRef.onValue.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<String, dynamic>> tempBookings = [];
        for (var entry in data.entries) {
          final bookingData = entry.value;
          final packageId = bookingData['package_id'];
          final userId = bookingData['user_id'];

          // Fetch package name
          final packageSnapshot = await FirebaseDatabase.instance
              .ref()
              .child('packages')
              .child(packageId)
              .get();
          final packageName = packageSnapshot.exists
              ? (packageSnapshot.value as Map)['package_name']
              : 'N/A';

          // Fetch user name
          final userSnapshot = await FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(userId)
              .get();
          final userName = userSnapshot.exists
              ? (userSnapshot.value as Map)['username']
              : 'N/A';

          tempBookings.add({
            'package_id': packageId,
            'package_name': packageName,
            'username': userName,
            'booking_date': bookingData['booking_date'],
            'status': bookingData['status'] ?? 'Paid',
          });
        }

        setState(() {
          bookings.clear();
          bookings.addAll(tempBookings);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 600), // Adjust for scrolling
            child: DataTable(
              columnSpacing: 10,
              dataRowHeight: 50,
              columns: [
                DataColumn(label: Text('Pck No')),
                DataColumn(label: Text('Package Name')),
                DataColumn(label: Text('User Name')),
                DataColumn(label: Text('Booking Date')),
                DataColumn(label: Text('Payment Status')),
              ],
              rows: bookings.map((booking) {
                return DataRow(cells: [
                  DataCell(Text(booking['package_id'] ?? 'N/A')),
                  DataCell(Text(booking['package_name'] ?? 'N/A')),
                  DataCell(Text(booking['username'] ?? 'N/A')),
                  DataCell(Text(booking['booking_date'] ?? 'N/A')),
                  DataCell(_buildPaymentStatusButton(booking['status'])),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the default selected index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });

          // Handle navigation based on selected index
          switch (index) {
            case 0: // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard(userId: '',)),
              );
              break;
            case 1: // Payment Status
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentStatusScreen()),
              );
              break;
            case 2: // Booking (Current screen)
              // Do nothing, we are already on the booking screen
              break;
            case 3: // Packing Status
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAdminScreen()),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed, // Ensures even space for all items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment Status'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildPaymentStatusButton(String status) {
    return ElevatedButton(
      onPressed: () {
        // Implement your logic here if needed
      },
      child: Text(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: status == 'Paid' ? Colors.green : Colors.red,
      ),
    );
  }
}
