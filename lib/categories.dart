import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travenour_app/adventure.dart'; // Ensure these files exist
import 'package:travenour_app/home.dart'; // Ensure this file exists
import 'package:travenour_app/search.dart'; // Ensure this file exists

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoriesScreen(),
    );
  }
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;
  final DatabaseReference _packagesDbRef = FirebaseDatabase.instance.ref().child('packages');
  final DatabaseReference _categoryDbRef = FirebaseDatabase.instance.ref().child('categories');
  List<Map<String, dynamic>> packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      final snapshot = await _packagesDbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> fetchedPackages = [];
        for (var packageSnapshot in snapshot.children) {
          final packageData = packageSnapshot.value as Map<dynamic, dynamic>;
          final categoryId = packageData['category_id'] ?? '';

          String categoryName = '';
          if (categoryId.isNotEmpty) {
            final categorySnapshot = await _categoryDbRef.child(categoryId).get();
            if (categorySnapshot.exists) {
              final categoryData = categorySnapshot.value as Map<dynamic, dynamic>;
              categoryName = categoryData['category_name'] ?? 'Unknown';
            }
          }

          final package = {
            'imageUrl': packageData['image_url'] ?? 'assets/default.png',
            'dateRange': packageData['date_range'] ?? '',
            'seatLeft': packageData['seat_limit'] ?? 0,
            'categoryName': categoryName,
            'categoryId': categoryId, // Add categoryId to the package
            'title': packageData['title']?.isNotEmpty == true ? packageData['title'] : categoryName,
          };
          fetchedPackages.add(package);
        }

        setState(() {
          packages = fetchedPackages;
        });
      }
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        // Add your Booking screen navigation here
        break;
      case 3:
        // Add your Profile screen navigation here
        break;
    }
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              'All Popular Trip Packages',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return InkWell(
                    onTap: () {
                      // Pass the categoryId when navigating to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdventureTripScreen(categoryId: package['categoryId']),
                        ),
                      );
                    },
                    child: TripCard(
                      imageUrl: package['imageUrl'],
                      title: package['title'],
                      dateRange: package['dateRange'],
                      seatLeft: package['seatLeft'],
                      categoryName: package['categoryName'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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

// TripCard widget
class TripCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateRange;
  final int seatLeft;
  final String categoryName;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateRange,
    required this.seatLeft,
    required this.categoryName,
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
            Container(
              width: screenWidth * 0.3,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
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
                      dateRange,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
                        'Seat Left: $seatLeft',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white,
                        ),
                      ),
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
