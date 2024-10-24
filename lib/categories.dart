import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'adventure.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;
  final DatabaseReference _packagesDbRef = FirebaseDatabase.instance.ref().child('packages');
  final DatabaseReference _categoryDbRef = FirebaseDatabase.instance.ref().child('categories');
  Map<String, List<Map<String, dynamic>>> categorizedPackages = {};

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      final snapshot = await _packagesDbRef.get();
      if (snapshot.exists) {
        Map<String, List<Map<String, dynamic>>> groupedPackages = {};
        for (var packageSnapshot in snapshot.children) {
          final packageData = packageSnapshot.value as Map<dynamic, dynamic>;
          final categoryId = packageData['category_id'] ?? '';

          if (categoryId.isNotEmpty) {
            // Fetch category name
            String categoryName = 'Unknown';
            final categorySnapshot = await _categoryDbRef.child(categoryId).get();
            if (categorySnapshot.exists) {
              final categoryData = categorySnapshot.value as Map<dynamic, dynamic>;
              categoryName = categoryData['category_name'] ?? 'Unknown';
            }

            final package = {
              'imageUrl': packageData['image_url'] ?? 'assets/default.png',
              'dateRange': packageData['date_range'] ?? '',
              'seatLeft': packageData['seat_limit'] ?? 0,
              'categoryName': categoryName,
              'categoryId': categoryId,
              'title': packageData['title']?.isNotEmpty == true ? packageData['title'] : categoryName,
            };

            // Group packages by category_id
            if (!groupedPackages.containsKey(categoryId)) {
              groupedPackages[categoryId] = [];
            }
            groupedPackages[categoryId]!.add(package);
          }
        }

        setState(() {
          categorizedPackages = groupedPackages;
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Categories',
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
              'Popular Categories',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: categorizedPackages.keys.length,
                itemBuilder: (context, index) {
                  final categoryId = categorizedPackages.keys.elementAt(index);
                  final categoryPackages = categorizedPackages[categoryId] ?? [];

                  if (categoryPackages.isNotEmpty) {
                    final firstPackage = categoryPackages[0]; // Use the first package to represent the category
                    return CategoryCard(
                      imageUrl: firstPackage['imageUrl'],
                      categoryName: firstPackage['categoryName'],
                      categoryId: firstPackage['categoryId'],
                      totalPackages: categoryPackages.length,
                    );
                  }
                  return SizedBox.shrink(); // If no packages, return an empty widget
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

// Updated CategoryCard to navigate to the next screen with category_id
class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String categoryName;
  final String categoryId;
  final int totalPackages;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.categoryName,
    required this.categoryId,
    required this.totalPackages,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Navigate to the next screen and pass categoryId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdventureTripScreen(categoryId: categoryId),
          ),
        );
      },
      child: Padding(
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
                        categoryName,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'Total Packages: $totalPackages',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


