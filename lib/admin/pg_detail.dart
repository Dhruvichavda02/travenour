import 'package:flutter/material.dart';
import 'add_package.dart';
import 'admin_dashboard.dart';
import 'booking_details.dart';
import 'payment_status_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Details',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PackageDetailsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PackageDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> packages = [
    {"pkgNo": 1, "pkgName": "Mussoorie", "amt": "10,000/-", "image": "assets/c1.png"},
    {"pkgNo": 2, "pkgName": "Kashmir", "amt": "10,000/-", "image": "assets/c1.png"},
    {"pkgNo": 3, "pkgName": "Goa", "amt": "10,000/-", "image": "assets/c1.png"},
    {"pkgNo": 4, "pkgName": "Las Vegas", "amt": "10,000/-", "image": "assets/c1.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 800), // Adjust minWidth for scrolling
            child: DataTable(
              columns: [
                DataColumn(label: Text('pkg no')),
                DataColumn(label: Text('Package Name')),
                DataColumn(label: Text('Amt')),
                DataColumn(label: Text('pck pic')),
                DataColumn(label: Text('Add Package')),
                DataColumn(label: Text('Delete Package')),
              ],
              rows: packages.map((package) {
                return DataRow(cells: [
                  DataCell(Text(package['pkgNo'].toString())),
                  DataCell(Text(package['pkgName'])),
                  DataCell(Text(package['amt'])),
                  DataCell(Image.asset(package['image'], width: 50, height: 50)),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPackageForm()),
                        );
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted successfully')),
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment_outlined), label: 'Payment Status'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Packing Status'),
        ],
        currentIndex: 3, // Set the selected index to 3 (Packing Status)
        selectedItemColor: Colors.blue,        // Color for selected item
        unselectedItemColor: Colors.grey,      // Color for unselected item
        showUnselectedLabels: true,            // Ensures labels are shown for unselected items
        type: BottomNavigationBarType.fixed,   // Ensure that all labels are shown
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentStatusScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingDetailsScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PackageDetailsScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
