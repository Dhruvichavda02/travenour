import 'package:flutter/material.dart';
import 'package:travenour_app/database_service.dart'; // Import your DatabaseService
import 'package:travenour_app/signin.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // Create TextEditingControllers for user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create an instance of DatabaseService
  final DatabaseService dbService = DatabaseService();

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
                'Please fill the details and create an account',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.03),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              TextField(
                controller: passwordController,
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
                onPressed: () async {
                  try {
                    // Call the addUser method with input values
                    await dbService.addUser(
                      nameController.text,  // User ID can be unique based on the name or another identifier
                      nameController.text,
                      emailController.text,
                      passwordController.text,  // In production, hash this password
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User added successfully!")),
                    );

                    // Navigate to the Sign In screen after successful registration
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Something went wrong!")),
                    );
                  }
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
                  style: TextStyle(fontSize: height * 0.02),
                ),
              ),
              SizedBox(height: height * 0.02),
              GestureDetector(
                onTap: () {
                  // Handle sign in tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
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
