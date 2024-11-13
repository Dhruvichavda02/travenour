import 'dart:convert'; // For Base64 encoding

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database_service.dart'; // Update with your actual import path

class AddPackageForm extends StatefulWidget {
  @override
  _AddPackageFormState createState() => _AddPackageFormState();
}

class _AddPackageFormState extends State<AddPackageForm> {
  String? selectedCategory;
  String? base64Image;

  final List<String> categories = [
    'Religious Retreat',
    'Adventures Activity',
    'Gender/Specific Trip',
    'Category-4',
  ];

  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _seatLimitController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Convert image to Base64 string
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Packages'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
              // Category Dropdown
              Text("Choose Category"),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: Text('Choose Category'),
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

              // Package Name TextField
              Text("Package Name"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _packageNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Name',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Package Description TextField
              Text("Package Description"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Description',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Price TextField
              Text("Price"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Price',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Facilities TextField
              Text("Facilities"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _facilitiesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Facilities (comma separated)',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Start Date TextField
              Text("Start Date"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Start Date (YYYY-MM-DD)',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // End Date TextField
              Text("End Date"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter End Date (YYYY-MM-DD)',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Total Days TextField
              Text("Total Days"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _totalDaysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Total Days',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Seat Limit TextField
              Text("Seat Limit"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _seatLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Seat Limit',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Image Upload Button
              Text("Upload Image"),
              SizedBox(height: screenHeight * 0.02),
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload_file),
                label: Text('Choose Image'),
              ),
              if (base64Image != null) ...[
                SizedBox(height: screenHeight * 0.02),
                Text("Image selected and ready for upload."),
              ],

              SizedBox(height: screenHeight * 0.05),

              // Add Package Button
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (selectedCategory != null) {
                      String packageName = _packageNameController.text;
                      String description = _descriptionController.text;
                      double price = double.parse(_priceController.text);
                      List<String> facilities = _facilitiesController.text.split(',').map((e) => e.trim()).toList();
                      String startDate = _startDateController.text;
                      String endDate = _endDateController.text;
                      int totalDays = int.parse(_totalDaysController.text);
                      int seatLimit = int.parse(_seatLimitController.text);

                      // Get the category ID or create a new one if it doesn't exist
                      String? categoryId = await DatabaseService().getCategoryId(selectedCategory!);
                      if (categoryId == null) {
                        // Add the new category using DatabaseService
                        String newCategoryId = DatabaseService().dbRef.child('categories').push().key!;
                        await DatabaseService().addCategory(categoryId: newCategoryId, categoryName: selectedCategory!);
                        categoryId = newCategoryId;
                      }

                      // Add the package with the obtained categoryId and Base64 image
                      await DatabaseService().addPackage(
                        packageName: packageName,
                        description: description,
                        categoryId: categoryId, // Pass the category ID
                        price: price,
                        facilities: facilities,
                        startDate: startDate,
                        endDate: endDate,
                        totalDays: totalDays,
                        seatLimit: seatLimit,
                        imageUrl: base64Image, // Use the Base64 image
                      );

                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Package added successfully!')),
                      );

                      // Clear the form fields
                      setState(() {
                        _packageNameController.clear();
                        _descriptionController.clear();
                        _priceController.clear();
                        _facilitiesController.clear();
                        _startDateController.clear();
                        _endDateController.clear();
                        _totalDaysController.clear();
                        _seatLimitController.clear();
                        selectedCategory = null;
                        base64Image = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a category!')),
                      );
                    }
                  },
                  child: Text('Add Package'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
