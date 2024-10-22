import 'package:flutter/material.dart';
import 'package:travenour_app/adventure_pk1.dart';
import 'package:travenour_app/categories.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdventureTripScreen(categoryId: '1'), // Pass a sample categoryId
    );
  }
}

class AdventureTripScreen extends StatefulWidget {
  final String categoryId; // Add the categoryId field
  const AdventureTripScreen({super.key, required this.categoryId}); // Mark categoryId as required

  @override
  _AdventureTripScreenState createState() => _AdventureTripScreenState();
}

class _AdventureTripScreenState extends State<AdventureTripScreen> {
  int _selectedIndex = 0;

  // Handle navigation when BottomNavigationBar item is clicked
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
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
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrekDetailsScreen()),
                      );
                    },
                    child: const TripCard(
                      imageUrl: 'assets/a1.png', // Replace with actual image path
                      title: 'Srinagar',
                      dateRange: '20 Sep - 29 Sep',
                      price: '17k',
                      details: '1N Srinagar',
                    ),
                  ),
                  const TripCard(
                    imageUrl: 'assets/a2.png', // Replace with actual image path
                    title: 'Kashmir',
                    dateRange: '20 Sep - 29 Sep',
                    price: '26k',
                    details: '1N Srinagar Houseboat | 1N Gulmarg | 2N Pahalgam | 1N Srinagar',
                  ),
                  const TripCard(
                    imageUrl: 'assets/a3.png', // Replace with actual image path
                    title: 'Mussoorie',
                    dateRange: '14 Nov - 22 Nov',
                    price: '14k',
                    details: '3N in Mussoorie',
                  ),
                  const TripCard(
                    imageUrl: 'assets/a4.png', // Replace with actual image path
                    title: 'Ladakh',
                    dateRange: '12 Dec - 18 Dec',
                    price: '18k',
                    details: '3N in Ladakh',
                  ),
                ],
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
  final String imageUrl;
  final String title;
  final String dateRange;
  final String price;
  final String details;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateRange,
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
            Container(
              width: screenWidth * 0.25,
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
                            price,
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
