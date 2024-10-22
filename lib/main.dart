import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travenour_app/SplashScreen.dart';

import 'categories.dart';
// import 'home.dart';

// import 'SplashScreen.dart';
// import 'admin/add_package.dart';
// import 'admin/admin_dashboard.dart';
// import 'admin/package_details.dart';

      

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter bindings are initialized
  await Firebase.initializeApp();  // Initialize Firebase here
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
      home:  CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
