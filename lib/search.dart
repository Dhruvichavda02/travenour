import 'package:flutter/material.dart';
import 'package:travenour_app/categories.dart';
// import 'package:travenour_app/filter.dart'; // Assuming you have this filter.dart file for the FilterScreen
import 'package:travenour_app/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Set the initial home screen here
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double _durationValue = 3; // Default value for duration slider
  double _priceValue = 50000; // Default value for price slider

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to the HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Change this if needed
            );
          },
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centers the title
        actions: [
          TextButton(
            onPressed: () {
              // Add cancel action
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25), // Adjust height as needed

              // Search Bar with Filter Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55, // Set desired height of the search bar
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Places',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: const Color.fromARGB(255, 236, 236, 236), // Background color for the search bar
                          prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 105, 88, 88), size: 24), // Increase size if needed
                          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Adjust vertical padding
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
                  const SizedBox(width: 1), // Space between TextField and Filter Button
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey), // Filter icon
                    onPressed: () {
                      _showFilterDialog(context, screenWidth); // Show filter dialog when button is pressed
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20), // Space between search bar and title

              // Section title
              const Text(
                'Search Places',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),

              // Places Grid with Constrained height
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Constrain the GridView height to avoid overflow
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: const [
                    PlaceCard(
                      imageUrl: 'assets/havelock.png', // Replace with your asset path
                      title: 'Havelock Island',
                      location: 'Andaman',
                    ),
                    PlaceCard(
                      imageUrl: 'assets/coorg.png', // Replace with your asset path
                      title: 'Coorg',
                      location: 'Karnataka',
                    ),
                    PlaceCard(
                      imageUrl: 'assets/ldd.png', // Replace with your asset path
                      title: 'Ladakh',
                      location: 'Ladakh',
                    ),
                    PlaceCard(
                      imageUrl: 'assets/jaipur.png', // Replace with your asset path
                      title: 'Jaipur',
                      location: 'Rajasthan',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter dialog code
  void _showFilterDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Duration:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _durationValue,
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: "${_durationValue.round()}N",
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _durationValue = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1N"),
                        Text("7N"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Price range:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _priceValue,
                      min: 1000,
                      max: 100000,
                      divisions: 100,
                      label: "\$${_priceValue.round()}",
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _priceValue = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("\$1k"),
                        Text("\$100k"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.6, // Responsive apply button width
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop(); // Close the filter dialog
                                               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen() ),
                 );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Apply"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;

  const PlaceCard({super.key, 
    required this.imageUrl,
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
            offset: const Offset(0, 7), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 130, // Adjust the image height if needed
              width: double.infinity,
              fit: BoxFit.cover, // Ensure the image covers the width of the container
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
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
}