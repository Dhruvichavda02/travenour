import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // For Firebase Realtime Database

import 'signin.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Reference to Firebase Realtime Database

  bool isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      String email = emailController.text.trim();

      // Check if email already exists in the database
      DatabaseReference usersRef = _dbRef.child("users");
      DataSnapshot snapshot = await usersRef.orderByChild("email").equalTo(email).get();

      if (snapshot.exists) {
        // Email already exists, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email already exists. Please sign in.")),
        );
      } else {
        // Email does not exist, proceed with the sign-up

        // Create a unique user ID using the push method
        String userId = _dbRef.child("users").push().key!; // Generate a unique key for the user

        // Store user details in Realtime Database
        await _dbRef.child("users").child(userId).set({
          'user_id': userId, // Store user ID
          'username': usernameController.text.trim(),
          'email': email, // Store email
          'password': passwordController.text.trim(), // Hash the password in production
          'role': 'user', // Default role is user
        });

        // Navigate to the Sign-In screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up now",
                style: TextStyle(
                  fontSize: screenHeight * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: isLoading ? null : _signUp,
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
