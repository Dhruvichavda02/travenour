import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'signin.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _userId = ''; // Store the user ID here

  @override
  void initState() {
    super.initState();
    // Fetch user ID when the widget is initialized
    _fetchUserId();
  }

  void _fetchUserId() {
    // Here, implement the actual logic to fetch the user ID
    // Replace this with actual logic to get the user ID, e.g., from the previous screen or session.
    setState(() {
      _userId = 'actual_user_id'; // Replace with actual logic
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF06001A),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.090,
                      color: const Color(0xFFD8AFCC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Text(
                    'User ID: $_userId',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.032),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.032),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _setPassword,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.010),
                        backgroundColor: const Color(0xFF31B3CD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'SET',
                        style: TextStyle(
                          fontSize: screenHeight * 0.0245,
                          color: const Color(0xFF06001A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.032),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setPassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validation for empty fields
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    // Check if the new password matches the confirm password
    if (newPassword == confirmPassword) {
      try {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(_userId);

        // Update password in the database
        await userRef.update({'password': newPassword});

        // Navigate to the sign-in screen after successful update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      } catch (e) {
        print('Error updating password: ${e.toString()}');
        _showErrorDialog('Failed to update password. Please try again.');
      }
    } else {
      _showErrorDialog('The new password and confirmation do not match.');
    }
  }

  // Helper function to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
