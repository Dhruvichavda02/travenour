import 'package:flutter/material.dart';
import 'package:travenour_app/home.dart';

// import 'admin/revenue_screen.dart';
// import 'package:travenour_app/SplashScreen.dart';

import 'admin/admin_dashboard.dart';
import 'admin/pg_detail.dart';

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
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
