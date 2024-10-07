

import 'package:flutter/material.dart';

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

class BookingDetailsScreen extends StatelessWidget {
  final List<Map<String, String>> bookings = [
    {'package': 'Manali', 'user': 'Diya', 'date': '28 Jan, 12:30 AM', 'status': 'Done'},
    {'package': 'Ladakh', 'user': 'Siya', 'date': '28 Jan, 12:30 AM', 'status': 'Done'},
    {'package': 'Mussoorie', 'user': 'Raj', 'date': '28 Jan, 12:30 AM', 'status': 'Done'},
    {'package': 'Tokyo', 'user': 'Riya', 'date': '28 Jan, 12:30 AM', 'status': 'Done'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        leading: Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 0.5, color: Colors.grey),
              ),
              children: [
                TableRow(
                  children: [
                    _buildTableHeader('Pck No'),
                    _buildTableHeader('Package Name'),
                    _buildTableHeader('User Name'),
                    _buildTableHeader('Booking Date'),
                    _buildTableHeader('Payment Status'),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Table(
                    border: TableBorder.symmetric(
                      inside: BorderSide(width: 0.2, color: Colors.grey),
                    ),
                    columnWidths: {
                      0: FractionColumnWidth(0.1),
                      1: FractionColumnWidth(0.2),
                      2: FractionColumnWidth(0.2),
                      3: FractionColumnWidth(0.3),
                      4: FractionColumnWidth(0.2),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell('${index + 1}'),
                          _buildTableCell(booking['package']!),
                          _buildTableCell(booking['user']!),
                          _buildTableCell(booking['date']!),
                          _buildPaymentStatusButton(booking['status']!),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Packing Status',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPaymentStatusButton(String status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}