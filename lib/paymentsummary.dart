import 'package:flutter/material.dart';
import 'dart:async';

import 'package:travenour_app/home.dart'; // Import for Future.delayed

class CreditCardPaymentScreen extends StatelessWidget {
  const CreditCardPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: screenHeight * 0.08, // Responsive toolbar height
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Go back to previous page
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: EdgeInsets.all(screenWidth * 0.08), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02), // Responsive space
            Center(
              child: Text(
                'Fill Details',
                style: TextStyle(
                  fontSize: screenWidth * 0.065, // Responsive title size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive space

            // Name on card field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name on card',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive space

            // Card number field
            TextField(
              decoration: InputDecoration(
                labelText: 'Card number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive space

            // Expiration date and security code in a row
            Row(
              children: [
                // Expiration date field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiration date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(
                    width:
                        screenWidth * 0.05), // Responsive space between fields

                // Security code field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Security code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive space

            // Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Show success dialog after clicking Pay
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        content: PaymentSuccessDialog(),
                      );
                    },
                  );

                  // Navigate to HomeScreen after 2 seconds
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.25, // Responsive button width
                    vertical: screenHeight * 0.013, // Responsive button height
                  ),
                  backgroundColor: Colors.blue, // Change button color to blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Change text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.7, // Responsive dialog width
      height: screenHeight * 0.4, // Responsive dialog height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular icon with checkmark
          Container(
            width: screenWidth * 0.2,
            height: screenHeight * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: screenWidth * 0.15, // Responsive icon size
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03), // Space below icon
          // Payment success message
          Text(
            'Payment Successful',
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
