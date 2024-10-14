import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen width to apply responsive layout
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture with Change Picture option
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15, // Responsive size
                      backgroundImage: AssetImage('assets/apk1.png'),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Handle profile picture change
                      },
                      child: Text(
                        'Change Profile Picture',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // First Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  suffixIcon: Icon(Icons.check, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                initialValue: 'Joey',
              ),
              SizedBox(height: 20),
              // Last Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  suffixIcon: Icon(Icons.check, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                initialValue: 'Tribbiani',
              ),
              SizedBox(height: 20),
              // Location Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  suffixIcon: Icon(Icons.check, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                initialValue: 'Rajkot',
              ),
              SizedBox(height: 20),
              // Mobile Number Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixText: '+88  ',
                  suffixIcon: Icon(Icons.check, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
                initialValue: '01758-000666',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, 50), // Full width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Set current tab index
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation taps
          switch (index) {
            case 0:
              // Navigate to Home
              break;
            case 1:
              // Navigate to Payment Status
              break;
            case 2:
              // Navigate to Booking
              break;
            case 3:
              // Stay on Profile page
              break;
          }
        },
      ),
    );
  }
}
