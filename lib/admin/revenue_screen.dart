import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add fl_chart package for the line chart

class RevenueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Revenue"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Add an index to manage selected item
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context); // Go back to Home
              break;
            case 1:
              Navigator.pushNamed(context, '/paymentStatus'); // Navigate to Payment Status
              break;
            case 2:
              Navigator.pushNamed(context, '/bookingDetails'); // Navigate to Booking Details
              break;
            case 3:
              Navigator.pushNamed(context, '/packageDetails'); // Navigate to Package Status
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Packing Status',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gross Profit section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Gross Profit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.06, // Responsive font size
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹5,00,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.1, // Responsive large text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Yearly Revenue Chart section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yearly Revenue',
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: height * 0.4, // Responsive chart height
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return Text('2016');
                                      case 1:
                                        return Text('2017');
                                      case 2:
                                        return Text('2018');
                                      case 3:
                                        return Text('2019');
                                      case 4:
                                        return Text('2020');
                                      case 5:
                                        return Text('2021');
                                    }
                                    return Container();
                                  },
                                  reservedSize: 30,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 10000,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 10000 == 0) {
                                      return Text(value.toString());
                                    }
                                    return Container();
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 10000),
                                  FlSpot(1, 15000),
                                  FlSpot(2, 18000),
                                  FlSpot(3, 25000),
                                  FlSpot(4, 23000),
                                  FlSpot(5, 35000),
                                ],
                                isCurved: true,
                                barWidth: 4,
                                color: Colors.blue, // Chart color
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
