import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'add_package.dart';
import 'admin_dashboard.dart';
import 'booking_details.dart';
import 'payment_status_screen.dart';
import 'update_package.dart';

class PackageDetailsScreen extends StatefulWidget {
  @override
  _PackageDetailsScreenState createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  final DatabaseReference _packageDbRef = FirebaseDatabase.instance.ref().child('packages');
  final DatabaseReference _categoryDbRef = FirebaseDatabase.instance.ref().child('categories');
  List<Map<String, dynamic>> packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages(); // Fetch packages from Firebase
  }

  // Function to fetch package details from Firebase, including category name
  Future<void> _fetchPackages() async {
    try {
      final snapshot = await _packageDbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> fetchedPackages = [];
        for (var packageSnapshot in snapshot.children) {
          final packageData = packageSnapshot.value as Map<dynamic, dynamic>;
          final categoryId = packageData['category_id'] ?? '';

          // Fetch the category name based on the category ID
          String categoryName = '';
          if (categoryId != '') {
            final categorySnapshot = await _categoryDbRef.child(categoryId).get();
            if (categorySnapshot.exists) {
              final categoryData = categorySnapshot.value as Map<dynamic, dynamic>;
              categoryName = categoryData['category_name'] ?? 'Unknown';
            }
          }

          final package = {
            'id': packageSnapshot.key,
            'pkgNo': packageData['package_id'] ?? '',
            'pkgName': packageData['package_name'] ?? '',
            'amt': packageData['price']?.toString() ?? '',
            'categoryName': categoryName, // Add the category name to the package map
          };
          fetchedPackages.add(package);
        }

        setState(() {
          packages = fetchedPackages; // Update the state with fetched data
        });
      }
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  // Function to delete a package from Firebase
  Future<void> _deletePackage(String packageId) async {
    try {
      // Remove the package from Firebase using the package ID
      await _packageDbRef.child(packageId).remove();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package deleted successfully')),
      );

      // Refresh the package list after deletion
      _fetchPackages();
    } catch (e) {
      print('Error deleting package: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete package')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // "Add Package" card above the table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.add, color: Colors.green),
                  title: Text('Add a New Package'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPackageForm()),
                      );
                    },
                    child: Text('Add Package'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 1000), // Adjust minWidth for scrolling
                child: DataTable(
                  columnSpacing: 20, // Add spacing between columns
                  dataRowHeight: 60, // Set height for each row
                  columns: [
                    DataColumn(label: Text('Pkg No')),
                    DataColumn(label: Text('Package Name')),
                    DataColumn(label: Text('Amt')),
                    DataColumn(label: Text('Category')), // Add Categories column
                    DataColumn(label: Text('Update Package')),
                    DataColumn(label: Text('Delete Package')),
                  ],
                  rows: packages.map((package) {
                    return DataRow(cells: [
                      DataCell(Text(package['pkgNo'].toString())),
                      DataCell(Text(package['pkgName'])),
                      DataCell(Text(package['amt'])),
                      DataCell(Text(package['categoryName'])), // Display the category name
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePackageForm(
                                  packageId: package['id'], // Pass package_id to UpdatePackageForm
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text('Are you sure you want to delete this package?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deletePackage(package['id']); // Call the delete function
                                        Navigator.of(context).pop(); // Close the dialog after deletion
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
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
          ],
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
