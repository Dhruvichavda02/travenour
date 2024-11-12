import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travenour_app/signin.dart'; // Ensure SignIn screen is properly imported.

void main() => runApp(AdminProfile());

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileEditScreen(),
      
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchUserData();
  }

  Future<void> _loadUserIdAndFetchUserData() async {
    // Load the user_id from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');
    if (userId != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch the user data from Firebase Realtime Database
      final snapshot = await _databaseReference.child('users/$userId').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Update the text controllers with fetched data
        setState(() {
          _firstNameController.text = data['username'] ?? '';
          _lastNameController.text = data['email'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _updateUserData() async {
    try {
      // Update data in Firebase Realtime Database
      if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty) {
        final updatedData = {
          'username': _firstNameController.text,
          'email': _lastNameController.text,
        };

        await _databaseReference.child('users/$userId').update(updatedData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
      } else {
        // Show error message if name or email is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name and Email cannot be empty")),
        );
      }
    } catch (error) {
      // Show failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile")),
      );
      print('Error updating user data: $error');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: _updateUserData, // Update functionality on "Done"
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
                      backgroundImage: AssetImage('assets/admin_profile.jpg'), // Default profile image
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  "${_firstNameController.text} ", // Username will be displayed
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField("Name", _firstNameController),
              _buildTextField("Email", _lastNameController),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmLogout,
                  child: const Text("Logout"),
                ),
              ),
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
