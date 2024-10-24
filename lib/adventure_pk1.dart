import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'books.dart';
import 'categories.dart'; // Import for Firebase

class TrekDetailsScreen extends StatefulWidget {
  final String packageId;

  const TrekDetailsScreen({super.key, required this.packageId});

  @override
  _TrekDetailsScreenState createState() => _TrekDetailsScreenState();
}

class _TrekDetailsScreenState extends State<TrekDetailsScreen> {
  int _currentIndex = 2;
  Map<String, dynamic>? packageDetails;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails(widget.packageId); // Fetch package details on init
  }

  // Fetch package details from Firebase based on packageId
  Future<void> _fetchPackageDetails(String packageId) async {
    DatabaseReference packageRef = FirebaseDatabase.instance
        .ref()
        .child('packages')
        .child(packageId);

    final snapshot = await packageRef.get();

    if (snapshot.exists) {
      setState(() {
        packageDetails = Map<String, dynamic>.from(snapshot.value as Map);
        isLoading = false; // Data is loaded
      });
    } else {
      print('Package not found!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      // Show a loading spinner while data is loading
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (packageDetails == null) {
      // Show an error message if the package details are null
      return Scaffold(
        body: Center(child: Text("No package details found.")),
      );
    }

    // Extracting the fetched details
    String startDate = packageDetails!['start_date'] ?? 'N/A';
    String endDate = packageDetails!['end_date'] ?? 'N/A';
    List facilities = packageDetails!['facilities'] ?? [];
    int totalDays = packageDetails!['total_days'] ?? 0;
    String description = packageDetails!['description'] ?? 'No description available';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/apk1.png'), // Use your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: screenWidth * 0.45 - 15,
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ],
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date: $startDate',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'End Date: $endDate',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Facilities',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Displaying facilities
                  Wrap(
                    spacing: 8.0,
                    children: facilities
                        .map((facility) => Chip(label: Text(facility.toString())))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Days: $totalDays',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingForm()),
                    );
                  },
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.airplane_ticket,
              color: _currentIndex == 2 ? Colors.grey : Colors.grey,
            ),
            label: 'Booking',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        
        },
      ),
    );
  }
}
