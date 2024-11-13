import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database
import 'dart:convert';

import 'adventure_pk1.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _packagesRef = FirebaseDatabase.instance.ref().child('packages'); // Reference to the packages node in Firebase
  List<Map<String, dynamic>> _packageNames = []; // List to store package maps
  List<Map<String, dynamic>> _filteredPackages = []; // List to store filtered results based on search query

  // For Filter
  RangeValues _priceRange = const RangeValues(2, 100000); // Default price range

  @override
  void initState() {
    super.initState();
    _fetchPackages(); // Fetch package names when the screen is initialized
  }

  // Method to fetch all package data from Firebase
  void _fetchPackages() async {
    DataSnapshot snapshot = await _packagesRef.get(); // Get all data from the packages node
    if (snapshot.exists) {
      Map data = snapshot.value as Map; // Assuming the data is a map
      List<Map<String, dynamic>> packageData = [];
      data.forEach((key, value) {
        packageData.add({
          'packageId': key,
          'package_name': value['package_name'] ?? '',
          'location': value['location'] ?? '',
          'imageurl': value['imageurl'] ?? 'assets/c1.png', // Provide default image if imageurl is null
          'price': value['price'] ?? 0, // Assuming price is a field in the package data
        });
      });
      setState(() {
        _packageNames = packageData;
        _filteredPackages = packageData; // Initially show all packages
      });
    }
  }

  // Method to filter packages based on search query and price range
  void _filterPackages(String query) {
    List<Map<String, dynamic>> results = _packageNames
        .where((package) => package['package_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()) &&
            package['price'] >= _priceRange.start &&
            package['price'] <= _priceRange.end)
        .toList();
    setState(() {
      _filteredPackages = results;
    });
  }

  // Show filter dialog for price range
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        RangeValues _tempPriceRange = _priceRange;  // Temp variable

        return StatefulBuilder(  // Use StatefulBuilder for local state inside the dialog
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Filter"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price Range Slider
                  const Text("Price range:"),
                  RangeSlider(
                    values: _tempPriceRange,
                    min: 2,
                    max: 100000,
                    divisions: 10,
                    labels: RangeLabels(
                      "${_tempPriceRange.start.round()}",
                      "${_tempPriceRange.end.round()}",
                    ),
                    onChanged: (RangeValues newRange) {
                      setDialogState(() {
                        _tempPriceRange = newRange;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Apply the filter and close the dialog
                    setState(() {
                      _priceRange = _tempPriceRange;  // Update the main state when dialog is closed
                    });
                    _filterPackages(_searchController.text);  // Apply filter immediately after updating the price range
                    Navigator.pop(context);
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     appBar: AppBar(
  backgroundColor: Colors.white,
  toolbarHeight: 80, // Increase the height of the AppBar
  elevation: 0, // Remove shadow for a clean look
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: const Text(
    'Search',
    style: TextStyle(
      color: Colors.black, 
      fontWeight: FontWeight.bold, 
      fontSize: 24 // Increase the font size for a larger title
    ),
  ),
  centerTitle: true,
),
 backgroundColor: Colors.white,
      body: Padding(
       
        padding: const EdgeInsets.all(16.0),
        child: Column(
       
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            const SizedBox(height: 25),
            // Search Bar
            Row(
           
              children: [
                Expanded(

                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterPackages, // Filter packages on text change
                      decoration: InputDecoration(
                        hintText: 'Search Places',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 236, 236, 236),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 105, 88, 88), size: 24),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 247, 241, 241)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
                // Add filter icon next to the search bar
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: _showFilterDialog, // Show filter dialog when filter icon is pressed
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Search Places',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 35),
            // Display filtered places
            Expanded(
              child: GridView.builder(
                itemCount: _filteredPackages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  var package = _filteredPackages[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to detailed view
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrekDetailsScreen(packageId: package['packageId']),
                        ),
                      );
                    },
                    child: PlaceCard(
                      imageurl: package['imageurl'],
                      title: package['package_name'],
                      location: package['location'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final String imageurl;
  final String title;
  final String location;

  const PlaceCard({
    super.key,
    required this.imageurl,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: _getImageProvider(imageurl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to display images (network, base64, or asset)
  Widget _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.startsWith('/9j/')) {
      return Image.memory(
        base64Decode(imageUrl),
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imageUrl,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }
}
