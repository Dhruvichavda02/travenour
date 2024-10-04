// import 'package:flutter/material.dart';

// class SecondSlide extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               width: 375,
//               height: 444,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/boat.png'),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//           // Onboard Box
//           Positioned(
//             left: 20,
//             top: 80, // Adjusted position for visibility
//             child: Container(
//               width: 360,
//               height: 800,
//               decoration: BoxDecoration(
//                 color: Colors.white, // Move color into decoration
//                 border: Border.all(color: Colors.black),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//           // Skip Button
//           Positioned(
//             left: 20,
//             top: 20,
//             child: Text(
//               'Skip',
//               style: TextStyle(
//                 fontFamily: 'Gill Sans MT',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 18,
//                 height: 24 / 18,
//                 color: Color(0xFFCAEAFF),
//               ),
//             ),
//           ),
//           // Get Started Button
//           Positioned(
//             left: 20,
//             top: 716,
//             child: Container(
//               width: 335,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: Color(0xFF0D6EFD), // Move color into decoration
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(
//                     fontFamily: 'SF UI Display',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     height: 20 / 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Life is short and the world is wide Text
//           Positioned(
//             left: 33,
//             top: 484,
//             child: Text(
//               'Life is short and the world is wide',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Geometr415 Blk BT',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 30,
//                 height: 36 / 30,
//                 color: Color(0xFF1B1E28),
//               ),
//             ),
//           ),
//           // Additional Text
//           Positioned(
//             left: 36,
//             top: 575.3,
//             child: Text(
//               '22 Tak Padhai, 25 pe Naukri, 26 pe Chokri, 30 pe bachche, 60 pe retirement … Aur phir maut ka intezaar … Dhat Aisi Ghisi Piti life Thodi Jeena Chahta hain?!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Gill Sans MT',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16,
//                 height: 24 / 16,
//                 color: Color(0xFF7D848D),
//               ),
//             ),
//           ),
//           // Status Bar
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               width: 375,
//               height: 48,
//               color: Colors.black.withOpacity(0.35),
//               child: Stack(
//                 children: [
//                   // Battery
//                   Positioned(
//                     right: 20.67,
//                     top: 19.33,
//                     child: Container(
//                       width: 22,
//                       height: 11.33,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white),
//                         borderRadius: BorderRadius.circular(2.67),
//                       ),
//                       child: Stack(
//                         children: [
//                           // Cap
//                           Positioned(
//                             right: 18.34,
//                             top: 23,
//                             child: Container(
//                               width: 1.33,
//                               height: 4,
//                               color: Colors.white.withOpacity(0.4),
//                             ),
//                           ),
//                           // Capacity
//                           Positioned(
//                             right: 22.67,
//                             top: 21.33,
//                             child: Container(
//                               width: 18,
//                               height: 7.33,
//                               color: Colors.white,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(1.33),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Wifi
//                   Positioned(
//                     right: 47.76,
//                     top: 20,
//                     child: Container(
//                       width: 14.74,
//                       height: 11,
//                       color: Colors.white,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 83.33,
//                             right: 12.74,
//                             top: 41.67,
//                             bottom: 48.42,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                           Positioned(
//                             left: 84.02,
//                             right: 13.42,
//                             top: 49.6,
//                             bottom: 42.81,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                           Positioned(
//                             left: 84.7,
//                             right: 14.11,
//                             top: 57.53,
//                             bottom: 35.42,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Cellular Connection
//                   Positioned(
//                     right: 68.27,
//                     top: 20,
//                     child: Container(
//                       width: 16.35,
//                       height: 10.67,
//                       color: Colors.white,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 77.44,
//                             right: 21.79,
//                             top: 55.56,
//                             bottom: 36.11,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                           Positioned(
//                             left: 78.63,
//                             right: 20.6,
//                             top: 51.39,
//                             bottom: 36.11,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                           Positioned(
//                             left: 79.83,
//                             right: 19.4,
//                             top: 46.53,
//                             bottom: 36.11,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                           Positioned(
//                             left: 81.03,
//                             right: 18.21,
//                             top: 41.67,
//                             bottom: 36.11,
//                             child: Container(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Time
//                   Positioned(
//                     left: 21,
//                     top: 12,
//                     child: Text(
//                       'Time',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontFamily: 'SF Pro Text',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                         height: 18 / 15,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Home Indicator
//           Positioned(
//             left: 0,
//             bottom: 8,
//             child: Container(
//               width: 375,
//               height: 34,
//               child: Center(
//                 child: Container(
//                   width: 134,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF1B1E28),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
