import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final List<Map<String, String>> users = [
    {
      "pkgNo": "1",
      "userName": "Diya",
      "pkgName": "Ladakh",
      "date": "28 Jan, 12:30 AM",
      "amount": "10,000/-",
      "paymentStatus": "Done"
    },
    {
      "pkgNo": "2",
      "userName": "Dhruvi",
      "pkgName": "Mumbai",
      "date": "1 Jan, 12:30 AM",
      "amount": "12,000/-",
      "paymentStatus": "Done"
    },
    {
      "pkgNo": "3",
      "userName": "Neha",
      "pkgName": "Goa",
      "date": "28 Jan, 12:30 AM",
      "amount": "15,000/-",
      "paymentStatus": "Done"
    },
    {
      "pkgNo": "4",
      "userName": "Priya",
      "pkgName": "Mount Abu",
      "date": "12 Feb, 12:30 AM",
      "amount": "9,000/-",
      "paymentStatus": "Done"
    },
    {
      "pkgNo": "5",
      "userName": "Vainhavi",
      "pkgName": "Dubai",
      "date": "28 Jan, 12:30 AM",
      "amount": "20,000/-",
      "paymentStatus": "Done"
    },
  ];

  UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Packing Status',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            return Column(
              children: [
                // Header
                Table(
                  border: const TableBorder(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                    4: IntrinsicColumnWidth(),
                    5: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(children: [
                      _tableHeader('Pkg no'),
                      _tableHeader('User Name'),
                      _tableHeader('Pkg Name'),
                      _tableHeader('Date'),
                      _tableHeader('Amount'),
                      _tableHeader('Payment'),
                    ]),
                  ],
                ),
                const SizedBox(height: 10),

                // List of users in table format
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Table(
                        border: TableBorder(
                          bottom:
                              BorderSide(color: Colors.grey[300]!, width: 0.5),
                        ),
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: IntrinsicColumnWidth(),
                          3: IntrinsicColumnWidth(),
                          4: IntrinsicColumnWidth(),
                          5: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            children: [
                              _tableCell(user['pkgNo']!),
                              _tableCell(user['userName']!),
                              _tableCell(user['pkgName']!),
                              _tableCell(user['date']!),
                              _tableCell(user['amount']!),
                              _paymentStatusButton(user['paymentStatus']!),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper widget for Table headers
  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for Table cells
  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  // Helper widget for Payment Status button
  Widget _paymentStatusButton(String status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent, // Green background color
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
        child: Text(status),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserDetailsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
