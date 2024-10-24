import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(); // Email controller
  String? _generatedOTP; // Initialize the OTP as nullable
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users'); // Reference to the user table

  // Function to check if the email is registered
  Future<bool> _isEmailRegistered(String email) async {
    bool isRegistered = false;

    try {
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        
        // Check if the email exists in the database
        for (var entry in data.entries) {
          if (entry.value['email']?.toLowerCase() == email.toLowerCase()) {
            isRegistered = true;
            break;
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching email: $e")),
      );
    }

    return isRegistered;
  }

  Future<void> sendOTPEmail(String email) async {
    // Ensure _generatedOTP is not null before sending the email
    if (_generatedOTP == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: OTP is not generated.")),
      );
      return;
    }

    final smtpServer = gmail('dchavda788@rku.ac.in', 'ieyq irim foma rimi'); // Use App Password here
    final message = Message()
      ..from = Address('dchavda788@rku.ac.in', 'Travenour')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP for resetting your password is $_generatedOTP.';

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to your email!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: email,
            generatedOTP: _generatedOTP!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Could not send OTP.")),
      );
    }
  }

  void resetPassword() async {
    String email = _emailController.text.trim(); // Get email directly

    if (email.isNotEmpty) {
      // Check if email is registered in the database
      bool isRegistered = await _isEmailRegistered(email);
      if (isRegistered) {
        _generatedOTP = (Random().nextInt(9000) + 1000).toString(); // Generate OTP
        await sendOTPEmail(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email not found.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Forgot password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email account to reset your password',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController, // Use email controller
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    resetPassword(); // Calls the resetPassword function
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}