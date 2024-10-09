import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add fl_chart package for the line chart

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
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
                      const SizedBox(height: 10),
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
                const SizedBox(height: 30),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: height * 0.4, // Responsive chart height
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text('2016');
                                      case 1:
                                        return const Text('2017');
                                      case 2:
                                        return const Text('2018');
                                      case 3:
                                        return const Text('2019');
                                      case 4:
                                        return const Text('2020');
                                      case 5:
                                        return const Text('2021');
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
                                  const FlSpot(0, 10000),
                                  const FlSpot(1, 15000),
                                  const FlSpot(2, 18000),
                                  const FlSpot(3, 25000),
                                  const FlSpot(4, 23000),
                                  const FlSpot(5, 35000),
                                ],
                                isCurved: true,
                                barWidth: 4,
                                color:
                                    Colors.blue, // Use color instead of colors
                                dotData: const FlDotData(show: false),
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

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RevenueScreen(),
    ));
