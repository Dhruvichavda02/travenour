import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'adventure_pk1.dart';
 // Import the TrekDetailsScreen

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdventureTripScreen(categoryId: 'some_category_id'), // Pass the category ID
    );
  }
}

class AdventureTripScreen extends StatefulWidget {
  final String categoryId; // Accept categoryId as a parameter

  const AdventureTripScreen({super.key, required this.categoryId});

  @override
  _AdventureTripScreenState createState() => _AdventureTripScreenState();
}

class _AdventureTripScreenState extends State<AdventureTripScreen> {
  int _selectedIndex = 0;
  final DatabaseReference _packagesRef = FirebaseDatabase.instance.ref('packages'); // Firebase reference for packages
  List<Map<String, dynamic>> _packages = []; // List to store packages fetched from Firebase
  bool _isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    _fetchPackages(); // Fetch packages when the screen loads
  }

  // Fetch packages based on the category_id passed to the screen
  void _fetchPackages() async {
    try {
      final DataSnapshot snapshot = await _packagesRef.orderByChild('category_id').equalTo(widget.categoryId).get();

      if (snapshot.exists) {
        final List<Map<String, dynamic>> loadedPackages = [];
        final packagesMap = snapshot.value as Map<dynamic, dynamic>;

        packagesMap.forEach((key, value) {
          loadedPackages.add({
            'id': key,
            'title': value['package_name'],
            'startDate': value['start_date'],   // Fetch start_date
            'endDate': value['end_date'],       // Fetch end_date
            'price': value['price'].toString(), // Convert price to string
            'details': value['description'],
            'imageUrl': value['image_url'],     // Assuming imageUrl exists in Firebase
          });
        });

        setState(() {
          _packages = loadedPackages;
          _isLoading = false; // Stop showing the loading spinner
        });
      }
    } catch (e) {
      print('Error fetching packages: $e');
      setState(() {
        _isLoading = false; // Stop showing the loading spinner even if an error occurs
      });
    }
  }

  // Handle navigation when BottomNavigationBar item is clicked
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigate to TrekDetailsScreen with package_id
  void _navigateToDetailsScreen(String packageId) {
   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TrekDetailsScreen(packageId: packageId)), // Use widget.categoryId
);

  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        title: const Text(
          'Adventure Trip',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Adventure Trip for Youth',
              style: TextStyle(
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
                  : ListView.builder(
                      itemCount: _packages.length,
                      itemBuilder: (context, index) {
                        final package = _packages[index];
                        return InkWell(
                          onTap: () {
                            // Pass package_id to TrekDetailsScreen
                            _navigateToDetailsScreen(package['id']);
                          },
                          child: TripCard(
                            title: package['title'],
                            startDate: package['startDate'],  // Pass startDate
                            endDate: package['endDate'],      // Pass endDate
                            price: package['price'],           // Pass price
                            details: package['details'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final String title;
  final String startDate;  // Add startDate
  final String endDate;    // Add endDate
  final String price;
  final String details;

  const TripCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Image container, if required
            Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'Start: $startDate',  // Display start date
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'End: $endDate',      // Display end date
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      details,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$price INR',  // Display price
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
