import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travenour_app/admin/add_admin.dart';
import 'package:travenour_app/admin/admin_dashboard.dart';
import 'package:travenour_app/admin/booking_details.dart';

class PaymentStatusScreen extends StatefulWidget {
  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final DatabaseReference _bookingsRef = FirebaseDatabase.instance.ref().child('bookings');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  List<Map<String, dynamic>> transactions = [];
  int _selectedIndex = 1;  // Keep the Payment Status tab selected

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  // Fetch transactions data from Firebase
  void _fetchTransactions() async {
    final dataSnapshot = await _bookingsRef.get();
    if (dataSnapshot.exists) {
      final data = dataSnapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> tempTransactions = [];

      for (var entry in data.entries) {
        final bookingData = entry.value;
        final userId = bookingData['user_id'];

        // Fetch username from 'users' node
        final userSnapshot = await _usersRef.child(userId).get();
        final userName = userSnapshot.exists
            ? (userSnapshot.value as Map)['username']
            : 'Unknown User';

        // Prepare the transaction data
        tempTransactions.add({
          'name': userName,
          'amount': bookingData['amount'],  // This is int, but we'll convert it later
          'date': bookingData['booking_date'],
          'status': bookingData['status'] ?? 'Pending',
        });
      }

      setState(() {
        transactions = tempTransactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Header with Blue Background
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "Payment Status",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Body Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 3, child: Text('Username', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      Expanded(flex: 3, child: Text('Payment Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      Expanded(flex: 2, child: Text('Payment Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    ],
                  ),
                  Divider(thickness: 1.5), // Divider to separate header from the list

                  // Transactions ListView
                  Expanded(
                    child: ListView(
                      children: transactions.map((transaction) {
                        return _buildTransactionRow(
                            transaction['name'],
                            transaction['amount'].toString(),  // Convert int to String here
                            transaction['date'],
                            transaction['status']);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Set currentIndex to the selected index
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment_outlined), label: 'Payment Status'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex when a tab is clicked
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard(userId: '',)));
              break;
            case 1:
              // Stay on Payment Status page (already here)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentStatusScreen()));
              break;
            case 2:
              // Navigate to Booking Page
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen()));
              break;
            case 3:
              // Navigate to Profile Page
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddAdminScreen()));
              break;
          }
        },
      ),
    );
  }

  // Helper function to build transaction rows
  Widget _buildTransactionRow(
      String name, String amount, String date, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Customer Name
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Amount
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // Date
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          // Payment Status
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentStatusScreen(),
    ));
