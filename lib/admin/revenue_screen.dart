import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueScreen extends StatelessWidget {
  // Function to fetch booking data from Firebase Realtime Database
Future<List<Map<String, dynamic>>> fetchBookingData() async {
  try {
    final DatabaseReference database = FirebaseDatabase.instance.ref('bookings');
    DataSnapshot snapshot = await database.get();
    
    List<Map<String, dynamic>> bookingData = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        String bookingDate = value['booking_date']; // dd/mm/yy format
        int year = _extractYear(bookingDate); // Extract year from booking_date
        
        bookingData.add({
          'year': year,   // Add extracted year
          'amount': value['amount'], // Assuming 'amount' field is present
        });
      });
    }
    return bookingData;
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}

// Helper function to extract the year from dd/mm/yy format
int _extractYear(String date) {
  try {
    List<String> dateParts = date.split('/'); // Split by '/'
    int year = int.parse(dateParts[2]); // Year is in the 3rd part
    return year;
  } catch (e) {
    print('Error extracting year from date: $e');
    return 0; // Return 0 in case of an error (fallback value)
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Revenue"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context); // Go back to Home
              break;
            case 1:
              Navigator.pushNamed(context, '/paymentStatus');
              break;
            case 2:
              Navigator.pushNamed(context, '/bookingDetails');
              break;
            case 3:
              Navigator.pushNamed(context, '/packageDetails');
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> bookingData = snapshot.data!;

          // Prepare data for the chart
       // Prepare data for the chart
List<FlSpot> spots = [];
for (int i = 0; i < bookingData.length; i++) {
  spots.add(FlSpot(i.toDouble(), bookingData[i]['amount']?.toDouble() ?? 0.0)); // Safely convert to double
}



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
                        'Income',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24, // Fixed font size for consistency
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
  '₹${bookingData.fold(0.0, (sum, item) => sum + (item['amount']?.toDouble() ?? 0.0))}',  // Ensure sum is a double
  style: TextStyle(
    color: Colors.white,
    fontSize: 32,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 300, // Chart height
                        child: LineChart(
                          LineChartData(
  gridData: FlGridData(show: true),
  titlesData: FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          int year = bookingData[value.toInt()]['year'];
          return Text(year.toString()); // Display the year
        },
        reservedSize: 30,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 5000,
        getTitlesWidget: (value, meta) {
          return Text(value.toString());
        },
        reservedSize: 40,
      ),
    ),
  ),
  borderData: FlBorderData(show: false),
  lineBarsData: [
    LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 4,
      color: Colors.blue,
      dotData: FlDotData(show: false),
    ),
  ],
)

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
