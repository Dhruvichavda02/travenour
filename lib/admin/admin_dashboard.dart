import 'package:flutter/material.dart';

import 'add_package.dart';
import 'cancel_refund_screen.dart';
import 'user_detail_screen.dart';

void main() {
  runApp(AdminDashboard());
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Add navigation logic
            },
          ),
        ),
        body: AdminDashboardBody(),
        bottomNavigationBar: BottomNavBar(),
      ),
      routes: {
        '/addPackageForm': (context) => AddPackageForm(),
         '/userdetail': (context) => UserDetailsScreen(),
         '/refunds_cancel': (context) => RefundsPage(),
         

       
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
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
                  icon: Icons.monetization_on_outlined, title: "Revenue",
                  
                  ),
              _buildDashboardItem(
                  icon: Icons.person_outline, title: "User Roles",
                   onTap: () {
                    // Navigate to AddPackageForm
                    Navigator.pushNamed(context, '/userdetail');
                  }),
              _buildDashboardItem(
                  icon: Icons.work_outline,
                  title: "Package Management",
                  onTap: () {
                    // Navigate to AddPackageForm
                    Navigator.pushNamed(context, '/addPackageForm');
                  }),
              _buildDashboardItem(
                  icon: Icons.money_off_outlined,
                  title: "Cancellation & Refunds",
                   onTap: () {
                    // Navigate to AddPackageForm
                    Navigator.pushNamed(context, '/refunds_cancel');
                  }),
            ],
          ),
        ],
      ),
    );
  }

  // Modify the _buildDashboardItem method to handle onTap
  Widget _buildDashboardItem(
      {required IconData icon, required String title, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap, // Add the onTap event
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
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
    );
  }
}
