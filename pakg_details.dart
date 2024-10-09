import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PackageDetailsScreen(),
    );
  }
}

class PackageDetailsScreen extends StatelessWidget {
  final List<Map<String, String>> packages = [
    {
      'name': 'Mussoorie',
      'amount': '10,000/-',
      'image': 'assets/images/mussoorie.jpg'
    },
    {
      'name': 'Kashmir',
      'amount': '10,000/-',
      'image': 'assets/images/kashmir.jpg'
    },
    {'name': 'Goa', 'amount': '10,000/-', 'image': 'assets/images/goa.jpg'},
    {
      'name': 'Las Vegas',
      'amount': '10,000/-',
      'image': 'assets/images/lasvegas.jpg'
    },
  ];

  PackageDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigating back to Admin Dashboard
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Image.asset(
                packages[index]['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(packages[index]['name']!),
              subtitle: Text(packages[index]['amount']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add action
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Add'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Delete action
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Del'),
                  ),
                ],
              ),
            ),
          );
        },
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
            icon: Icon(Icons.local_shipping),
            label: 'Packing Status',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
