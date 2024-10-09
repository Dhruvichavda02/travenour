import 'package:flutter/material.dart';

class AddPackageForm extends StatefulWidget {
  const AddPackageForm({Key? key}) : super(key: key);

  @override
  _AddPackageFormState createState() => _AddPackageFormState();
}

class _AddPackageFormState extends State<AddPackageForm> {
  String? selectedCategory;

  final List<String> categories = [
    'Religious Retreat',
    'Adventure Trip',
    'Boys / Girls Trip',
    'General',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Packages'),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Choose Category
              const Text("Choose Category"),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Choose Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              // Add Image
              const Text("Add Image"),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.6, // Make the Choose File button smaller
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      // File upload logic here
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Choose file'),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Package Name
              const Text("Package Name"),
              SizedBox(height: screenHeight * 0.02),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Name',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Package Description
              const Text("Package Description"),
              SizedBox(height: screenHeight * 0.02),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Description',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Price
              const Text("Price"),
              SizedBox(height: screenHeight * 0.02),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Price',
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Add Package Button
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Show success dialog after the package is added
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Package Added Successfully!!!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Add Package',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
