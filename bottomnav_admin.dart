import 'package:flutter/material.dart';
import '../admin_dashboard.dart';
import '../payment_status_screen.dart';

void main() {
  runApp(const BottomNavBar());
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set AdminDashboard as the home screen
      home: const AdminDashboard(), // Change this line to display AdminDashboard first
      routes: {
        '/dashboard': (context) => const AdminDashboard(),
        '/paymentStatus': (context) => const PaymentStatusScreen(),
      },
    );
  }
}

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate screen based on the index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/paymentStatus');
        break;
      case 2:
        // Implement navigation for booking screen here if needed
        break;
      case 3:
        // Implement navigation for packing status screen here if needed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Bottom Navigation Bar Screen"), // Placeholder for the main content
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Payment Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Packing Status',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
