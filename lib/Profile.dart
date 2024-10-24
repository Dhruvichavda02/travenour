import 'package:flutter/material.dart';
import 'package:travenour_app/Bookings.dart';
import 'package:travenour_app/home.dart';
import 'package:travenour_app/search.dart';

void main() => runApp(ProfileEditApp());

class ProfileEditApp extends StatelessWidget {
  const ProfileEditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileEditScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/booking': (context) => BookingScreen(),
        '/profile': (context) => ProfileEditScreen(),
      },
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _firstNameController = TextEditingController(text: "Joey");
  final _lastNameController = TextEditingController(text: "Tribanni");
  final _locationController = TextEditingController(text: "Rajkot");
  final _mobileNumberController =
      TextEditingController(text: "+88 01758-000666");

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: () {
              // Add your save functionality here
            },
            child: const Text("Done", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.15,
                      backgroundColor: Colors.pink.withOpacity(0.2),
                    ),
                    CircleAvatar(
                      radius: screenWidth * 0.14,
                      backgroundImage: const AssetImage(
                          'assets/profile_picture.png'), // Replace with actual image path
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  "Joey Tribbani",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add functionality to change profile picture
                },
                child: const Text("Change Profile Picture",
                    style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField("First Name", _firstNameController),
              _buildTextField("Last Name", _lastNameController),
              _buildTextField("Location", _locationController),
              _buildTextField("Mobile Number", _mobileNumberController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}

// Define the HomeScreen, SearchScreen, and BookingScreen classes

