import 'package:flutter/material.dart';
import 'add_admin.dart';
import 'admin_profile.dart';
import 'booking_details.dart';
import 'pg_detail.dart';
import 'revenue_screen.dart';
import 'payment_status_screen.dart';
import 'user_detail_screen.dart';

void main() {
  runApp(AdminDashboard(userId: '')); // Pass a sample userId for testing
}

class AdminDashboard extends StatelessWidget {
  final String userId;

  AdminDashboard({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: AdminDashboardBody(userId: userId),
        bottomNavigationBar: BottomNavBar(),
      ),
      routes: {
        '/revenue': (context) => RevenueScreen(),
        '/AddAdminScreen': (context) => AddAdminScreen(),
        '/paymentStatus': (context) => PaymentStatusScreen(),
        '/bookingDetails': (context) => BookingDetailsScreen(),
        '/packageDetails': (context) => PackageDetailsScreen(),
        '/useroles': (context) => UserDetailsScreen(),
        '/adminprofile': (context) => ProfileEditScreen(),
      },
    );
  }
}

class AdminDashboardBody extends StatelessWidget {
  final String userId;

  AdminDashboardBody({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  
                  "Welcome Admin",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                  
              ],
            ),
          ),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildDashboardItem(
                icon: Icons.monetization_on_outlined,
                title: "Revenue",
                onTap: () {
                  Navigator.pushNamed(context, '/revenue');
                },
              ),
              _buildDashboardItem(
                icon: Icons.person_outline,
                title: "User Roles",
                onTap: () {
                  Navigator.pushNamed(context, '/useroles');
                },
              ),
              _buildDashboardItem(
                icon: Icons.work_outline,
                title: "Package Management",
                onTap: () {
                  Navigator.pushNamed(context, '/packageDetails');
                },
              ),
              _buildDashboardItem(
                icon: Icons.person_add,
                title: "Add Admin",
                onTap: () {
                  Navigator.pushNamed(context, '/AddAdminScreen');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({required IconData icon, required String title, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.payment_outlined), label: 'Payment Status'),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Booking'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard(userId: 'sampleUserId')));
            break;
          case 1:
            Navigator.pushNamed(context, '/paymentStatus');
            break;
          case 2:
            Navigator.pushNamed(context, '/bookingDetails');
            break;
          case 3:
            Navigator.pushNamed(context, '/adminprofile');
            break;
        }
      },
    );
  }
}
