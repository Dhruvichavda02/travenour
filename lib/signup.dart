import 'package:flutter/material.dart';
import 'package:travenour_app/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for responsive layout
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign up now',
                style: TextStyle(
                  fontSize: height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Please fill the details and create account',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.03),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Password must be 8 characters',
                style: TextStyle(
                  fontSize: height * 0.018,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen() ),
                 );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Updated background color
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: height * 0.02,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              GestureDetector(
                onTap: () {
                  // Handle sign in tap
                },
                child: Text(
                  'Already have an account? Sign in',
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}