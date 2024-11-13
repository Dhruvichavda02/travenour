import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'books.dart';

class TrekDetailsScreen extends StatefulWidget {
  final String packageId;

  const TrekDetailsScreen({super.key, required this.packageId});

  @override
  _TrekDetailsScreenState createState() => _TrekDetailsScreenState();
}

class _TrekDetailsScreenState extends State<TrekDetailsScreen> {
  int _currentIndex = 2;
  Map<String, dynamic>? packageDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails(widget.packageId);
  }

  // Fetch package details from Firebase
  Future<void> _fetchPackageDetails(String packageId) async {
    DatabaseReference packageRef = FirebaseDatabase.instance
        .ref()
        .child('packages')
        .child(packageId);

    final snapshot = await packageRef.get();

    if (snapshot.exists) {
      setState(() {
        packageDetails = Map<String, dynamic>.from(snapshot.value as Map);
        isLoading = false;
      });

      // Fetch and print the imageUrl for debugging
      String? imageUrl = packageDetails!['imageurl'];
      print('Fetched imageUrl: $imageUrl');
    } else {
      print('Package not found!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (packageDetails == null) {
      return Scaffold(
        body: Center(child: Text("No package details found.")),
      );
    }

    // Extract package details and add debug prints
    String startDate = packageDetails!['start_date'] ?? 'N/A';
    String endDate = packageDetails!['end_date'] ?? 'N/A';
    List facilities = packageDetails!['facilities'] ?? [];
    int totalDays = packageDetails!['total_days'] ?? 0;
    String description = packageDetails!['description'] ?? 'No description available';
    int price = packageDetails!['price'] ?? 0;
    String? imageUrl = packageDetails!['imageurl']; // Get image URL

    print("Start Date: $startDate, End Date: $endDate, Facilities: $facilities, Total Days: $totalDays, Price: $price");

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
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: _getImageProvider(imageUrl),
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

            // Package Details
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
                    'Price: $price',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.normal,
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
                      MaterialPageRoute(
                          builder: (context) => BookingForm(packageId: widget.packageId, price: price)),
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

  // Helper function to decide how to load the image
 ImageProvider<Object> _getImageProvider(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return AssetImage('assets/coorg.png');
  }

  // Check if the URL starts with 'http' for a Network Image
  if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    print("Network Image URL: $imageUrl");  // Debug print
    return NetworkImage(imageUrl);
  }

  try {
    base64Decode(imageUrl); // Try to decode base64 if needed
    return MemoryImage(base64Decode(imageUrl));
  } catch (e) {
    print("Error decoding base64 image: $e");
    return AssetImage('assets/coorg.png');  // Fallback on error
  }
}

}
