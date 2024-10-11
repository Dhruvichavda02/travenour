import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                CircleAvatar(
                  radius: screenSize.width * 0.15, // Responsive radius
                  backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/150', // Placeholder for profile pic
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Vaibhavi Jilka",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.06, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    // Handle change profile picture action
                  },
                  child: const Text(
                    "Change Profile Picture",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),

                // First Name Field
                _buildTextField(
                  context: context,
                  label: "Name",
                  value: "Enter Your Name",
                ),
                const SizedBox(height: 15),

                // Last Name Field
                _buildTextField(
                  context: context,
                  label: "Email",
                  value: "Enter Your Email",
                ),
                const SizedBox(height: 15),

                // Location Field
                _buildTextField(
                  context: context,
                  label: "Password",
                  value: "Enter Your Password",
                ),
                const SizedBox(height: 15),

                const SizedBox(height: 30),
                // You can add save button here
                ElevatedButton(
                  onPressed: () {
                    // Handle save action
                  },
                  child: const Text("Add Admin"),
                ),
              ],
            ),
          ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(
                Icons.check,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
