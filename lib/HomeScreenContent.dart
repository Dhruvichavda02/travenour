import 'package:flutter/material.dart';
// import 'package:travenour_app/Bookings.dart';
// import 'package:travenour_app/Profile.dart';
// import 'package:travenour_app/books.dart';
// import 'package:travenour_app/search.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final headingFontSize = screenWidth * 0.11;
    final bodyFontSize = screenWidth * 0.045;
    final padding = screenWidth * 0.04;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.07),
              Text(
                "Explore the",
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Beautiful ",
                    style: TextStyle(
                      fontSize: headingFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "world!",
                    style: TextStyle(
                      fontSize: headingFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Best Destination",
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(
                      fontSize: bodyFontSize * 0.9,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.06),
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/alleppey_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Alleppey',
                style: TextStyle(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on,
                      size: bodyFontSize * 0.9, color: Colors.grey),
                  SizedBox(width: screenWidth * 0.01),
                  Text(
                    'Kerala',
                    style: TextStyle(
                      fontSize: bodyFontSize * 0.9,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'The blue Arabian sea, the towering Western Ghats. This then is Kerala, the most beautiful Indian state.',
                style: TextStyle(
                  fontSize: bodyFontSize,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
