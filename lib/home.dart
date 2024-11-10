import 'package:flutter/material.dart';
import 'package:travenour_app/Bookings.dart';
import 'package:travenour_app/HomeScreenContent.dart';
import 'package:travenour_app/Profile.dart';
import 'package:travenour_app/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(userId: 'dummyUserId'), // Pass userId here, or get it from login
    );
  }
}

// Define the HomeScreen class
class HomeScreen extends StatefulWidget {
  final String userId; // Add userId here to pass between screens

  const HomeScreen({Key? key, required this.userId}) : super(key: key); // Pass userId in the constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String userId; // Remove nullable, use late

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // Use userId from the passed widget
    _loadUserId(); // Optionally, you can load it from shared_preferences as well
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? userId; // Use stored ID or fallback to the passed one
    });
  }

  final List<Widget> _screens = [
    HomeScreenContent(),
    SearchScreen(),
    BookingScreen(),
    ProfileEditApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      // title: Text(""),
    ),
    body: Expanded(
      child: _screens[_currentIndex], // Display the current screen
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
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
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Add your action here, e.g., create a new booking
      },
      child: Icon(Icons.add),
    ),
  );
}

}
