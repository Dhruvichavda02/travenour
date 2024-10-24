import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'admin/admin_dashboard.dart';
import 'forgetpass_email.dart';
import 'home.dart';
import 'signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message on new login attempt
    });

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Fetch all users from the Firebase Realtime Database
      DataSnapshot snapshot = await _databaseRef.child('users').get();

      if (snapshot.exists && snapshot.value != null) {
        // Check the type of the value
        if (snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> usersData =
              snapshot.value as Map<dynamic, dynamic>;

          // Find the user by email
          final user = usersData.values.firstWhere(
            (user) =>
                user is Map &&
                user['email'] != null &&
                user['email'].toString().toLowerCase() == email.toLowerCase(),
            orElse: () => null,
          );

          if (user != null && user is Map) {
            // Log email and password for comparison
            print('Entered email: $email, Stored email: ${user['email']}');
            print(
                'Entered password: $password, Stored password: ${user['password']}');

            // Validate password
            if (user['password'].toString() == password) {
              print('Password matched for user: ${user['user_id']}');
              // Navigate based on the user's role
              if (user['role'] == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()),
                );
              }
            } else {
              _setErrorMessage("Incorrect password. Please try again.");
            }
          } else {
            _setErrorMessage("User not found. Please check your email.");
          }
        } else {
          _setErrorMessage(
              "Unexpected data structure. Please contact support.");
        }
      } else {
        _setErrorMessage("No users found in the database.");
      }
    } catch (error) {
      _setErrorMessage("An error occurred: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      print(_errorMessage); // Log the error message
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign in now",
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Please sign in to continue our app",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter Email',
                isPassword: false,
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Enter Password',
                isPassword: true,
              ),
              SizedBox(height: screenHeight * 0.02),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.05),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF0D6EFD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F7F9),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}