import 'package:flutter/material.dart';
import 'booking_details.dart';
import 'cancel_refund_screen.dart';



import 'pg_detail.dart';
import 'revenue_screen.dart';
import 'payment_status_screen.dart';

void main() {
  runApp(AdminDashboard());
  
}

class AdminDashboard extends StatelessWidget {
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
              // Add navigation logic if needed, or remove if not needed
              Navigator.pop(context);
            },
          ),
        ),
        body: AdminDashboardBody(),
        bottomNavigationBar: BottomNavBar(),
      ),
      routes: {
        '/revenue': (context) => RevenueScreen(),
        '/refunds_cancel': (context) => RefundsPage(), // Ensure RefundsPage is defined
        '/paymentStatus': (context) => PaymentStatusScreen(),
        '/bookingDetails': (context) => BookingDetailsScreen(),
        '/packageDetails': (context) => PackageDetailsScreen(),
      },
    );
  }
}

class AdminDashboardBody extends StatelessWidget {
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
                  // Add navigation if needed
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
                icon: Icons.money_off_outlined,
                title: "Cancellation & Refunds",
                onTap: () {
                  Navigator.pushNamed(context, '/refunds_cancel');
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
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Package Status'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
            break;
          case 1:
            Navigator.pushNamed(context, '/paymentStatus');
            break;
          case 2:
            Navigator.pushNamed(context, '/bookingDetails');
            break;
          case 3:
            Navigator.pushNamed(context, '/packageDetails');
            break;
        }
      },
    );
  }
}
