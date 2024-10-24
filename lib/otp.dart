import 'package:flutter/material.dart';
import 'package:travenour_app/signin.dart';

import 'CreatePasswordScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(), // Assuming you have a sign-in screen to start with
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy values for demonstration
    String email = 'joeyt@gmail.com'; // Replace with actual user input
    String generatedOTP = '1234'; // Replace with the actual generated OTP

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to OTPVerificationScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                  email: email,
                  generatedOTP: generatedOTP,
                ),
              ),
            );
          },
          child: const Text('Send OTP'),
        ),
      ),
    );
  }
}

class OTPVerificationScreen extends StatelessWidget {
  final String email;        // Email parameter
  final String generatedOTP; // Generated OTP parameter

  const OTPVerificationScreen({
    Key? key,
    required this.email,          // Make email required
    required this.generatedOTP,   // Make generated OTP required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'OTP Verification',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We have sent a verification code to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(  // Display the email that received the OTP
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _otpTextField(context),
                _otpTextField(context),
                _otpTextField(context),
                _otpTextField(context),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to SignInApp
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePasswordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable OTP text field widget
  Widget _otpTextField(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 24),
        maxLength: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }
}