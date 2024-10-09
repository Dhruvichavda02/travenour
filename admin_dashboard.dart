import 'package:flutter/material.dart';
import 'package:travenour_app/admin/user_detail_screen.dart';

import 'add_package.dart';
import 'booking_details.dart';
import 'cancel_refund_screen.dart';
// import 'user_detail_screen.dart';
import 'package_details.dart';
import 'payment_status_screen.dart';
import 'revenue_screen.dart'; // Import your PaymentStatusScreen

void main() {
  runApp(const AdminDashboard());
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const AdminDashboardBody(),
        bottomNavigationBar: const BottomNavBar(),
      ),
      routes: {
        '/addPackageForm': (context) => const AddPackageForm(),
        '/revenue': (context) => const RevenueScreen(),
        '/refunds_cancel': (context) => const RefundsPage(),
        '/paymentStatus': (context) => const PaymentStatusScreen(),
        '/userdetail': (context) => UserDetailsScreen(),
        '/bookingDetails': (context) => BookingDetailsScreen(),
        '/packageDetails': (context) =>
            PackageDetailsScreen() // Route for PaymentStatusScreen
      },
    );
  }
}

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Column(
              children: [
                SizedBox(height: 30),
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
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildDashboardItem(
                  icon: Icons.monetization_on_outlined,
                  title: "Revenue",
                  onTap: () {
                    Navigator.pushNamed(context, '/revenue');
                  } // Center the title
                  ),
              _buildDashboardItem(
                  icon: Icons.person_outline,
                  title: "User Roles",
                  onTap: () {
                    Navigator.pushNamed(context, '/userdetail');
                  }),
              _buildDashboardItem(
                  icon: Icons.work_outline,
                  title: "Package Management",
                  onTap: () {
                    Navigator.pushNamed(context, '/addPackageForm');
                  }),
              _buildDashboardItem(
                  icon: Icons.money_off_outlined,
                  title: "Cancellation & Refunds",
                  onTap: () {
                    Navigator.pushNamed(context, '/refunds_cancel');
                  }),
            ],
          ),
        ],
      ),
    );
  }

  // Modified _buildDashboardItem to allow centering of title
  Widget _buildDashboardItem(
      {required IconData icon,
      required String title,
      Function()? onTap,
      Alignment alignment = Alignment.topCenter}) {
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
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: alignment, // Set the alignment here
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        switch (index) {
          case 1:
            // Navigate to PaymentStatusScreen
            Navigator.pushNamed(context, '/paymentStatus');
            break;
          case 2:
            // Navigate to BookingDetailsScreen
            Navigator.pushNamed(context, '/bookingDetails');
            break;
          case 3:
            // Navigate to PackageDetailsScreen
            Navigator.pushNamed(context, '/packageDetails');
            break;
        }
      },
    );
  }
}
