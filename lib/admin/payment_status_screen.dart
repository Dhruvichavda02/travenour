import 'package:flutter/material.dart';

class PaymentStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Header with Blue Background
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "Payment Status",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Body Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the Transactions Section
                  Text(
                    "Recent Transaction",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Transactions Table
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTransactionRow(
                            "Rashmi", "10K", "28 Jan, 12.30 AM", "Done"),
                        Divider(),
                        _buildTransactionRow(
                            "Vidhi", "20K", "28 Jan, 12.30 AM", "Done"),
                        Divider(),
                        _buildTransactionRow(
                            "Ross", "25K", "28 Jan, 12.30 AM", "Done"),
                      ],
                    ),
                  ),

                  // View All Button
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0), // Move the button upwards
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle View All Pressed
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          backgroundColor: Colors.blue, // Background color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build transaction rows
  Widget _buildTransactionRow(
      String name, String amount, String date, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Customer Name
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Amount
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // Date
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          // Payment Status
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentStatusScreen(),
    ));
