import 'package:flutter/material.dart';
// import 'package:travenour_app/SplashScreen.dart';

import 'admin/admin_dashboard.dart';


void main() {
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
      home: AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
