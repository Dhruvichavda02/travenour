import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travenour_app/SplashScreen.dart'; // Ensure this is your correct import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'OpenSans',  
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
