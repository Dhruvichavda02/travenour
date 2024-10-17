import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // For Realtime Database
import 'package:travenour_app/forgetpass_email.dart'; 
import 'package:travenour_app/home.dart';
import 'package:travenour_app/signup.dart';
import 'admin/admin_dashboard.dart';

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
    });

    try {
      String email = _emailController.text.trim();
      String sanitizedEmail = email.replaceAll('.', ','); // Replace '.' to match storage key
      String password = _passwordController.text; 

      // Fetch all users
      DataSnapshot snapshot = await _databaseRef.child('users').get();

      if (snapshot.exists) {
        // Iterate through all users to find the matching email
        Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
        String? userId;
        String? storedPassword;
        String? role;

        usersData.forEach((key, value) {
          if (value['email'] == sanitizedEmail) {
            userId = value['user_id'];
            storedPassword = value['password'];
            role = value['role'];
          }
        });

        if (userId != null) {
          // Validate password
          if (storedPassword == password) {
            // Navigate based on the role
            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()), // Admin Dashboard
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // Normal Home screen
              );
            }
          } else {
            setState(() {
              _errorMessage = "Incorrect password. Please try again.";
            });
          }
        } else {
          setState(() {
            _errorMessage = "User not found. Please check your email.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "No users found in the database.";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  hintText: 'Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              
              // Forgot Password Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()), // Navigate to the forget password screen
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
                  ? CircularProgressIndicator() // Show a loading spinner
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
                    style: TextStyle(
                      color: Colors.grey,
                    ),
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
}
