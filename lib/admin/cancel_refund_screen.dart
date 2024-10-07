import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Refunds UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RefundsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RefundsPage extends StatelessWidget {
  const RefundsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Cancelled & Refunds Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Cancelled & Refunds Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildRefundTable(screenWidth),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget buildRefundTable(double screenWidth) {
    return DataTable(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text("Pkg no.")),
        DataColumn(label: Text("User Name")),
        DataColumn(label: Text("DT")),
        DataColumn(label: Text("Amt")),
        DataColumn(label: Text("Refunds")),
      ],
      rows: const [
        DataRow(
          cells: [
            DataCell(Text("1")),
            DataCell(Text("Vaibhavi")),
            DataCell(Text("28 Jan, 12.30 AM")),
            DataCell(Text("10,000/-")),
            DataCell(
              RefundStatus(status: 'Done', color: Colors.blue),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("2")),
            DataCell(Text("Neha")),
            DataCell(Text("28 Jan, 12.30 AM")),
            DataCell(Text("10,000/-")),
            DataCell(
              RefundStatus(status: 'Pending', color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

class RefundStatus extends StatelessWidget {
  final String status;
  final Color color;

  const RefundStatus({Key? key, required this.status, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
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
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        switch (index) {
          case 0:
            // Navigate to Home
            Navigator.pushReplacementNamed(context, '/'); // Change as per your main route
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
