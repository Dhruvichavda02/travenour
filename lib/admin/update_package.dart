import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:firebase_database/firebase_database.dart';

class UpdatePackageForm extends StatefulWidget {
  final String packageId;

  UpdatePackageForm({required this.packageId});

  @override
  _UpdatePackageFormState createState() => _UpdatePackageFormState();
}

class _UpdatePackageFormState extends State<UpdatePackageForm> {
  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController _facilitiesController = TextEditingController();
  TextEditingController _totalDaysController = TextEditingController();
  TextEditingController _packageNameController = TextEditingController();
  TextEditingController _packageDescriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  final List<String> categories = [
    'Religious Retreat',
    'Adventure Trip',
    'Boys / Girls Trip',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    fetchPackageDetails(widget.packageId);
  }

  Future<void> fetchPackageDetails(String packageId) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref('packages');

    try {
      DataSnapshot snapshot = await _databaseReference.child(packageId).get();
      if (snapshot.exists) {
        final Map<Object?, Object?>? packageData =
            snapshot.value as Map<Object?, Object?>?;

        if (packageData != null) {
          setState(() {
            selectedCategory = packageData['category_name'] as String?;

            // Parse start_date
            String? startDateValue = packageData['start_date'] as String?;
            startDate = startDateValue != null && startDateValue.isNotEmpty
                ? DateFormat('yyyy-MM-dd').parse(startDateValue)
                : null;

            // Parse end_date
            String? endDateValue = packageData['end_date'] as String?;
            endDate = endDateValue != null && endDateValue.isNotEmpty
                ? DateFormat('yyyy-MM-dd').parse(endDateValue)
                : null;

            // Handle facilities list
            List<Object?> facilitiesList = packageData['facilities'] as List<Object?>;
            _facilitiesController.text = facilitiesList.map((e) => e.toString()).join(', ');

            _totalDaysController.text =
                (packageData['total_days'] as num).toString();
            _packageNameController.text = packageData['package_name'] as String;
            _packageDescriptionController.text =
                packageData['description'] as String;
            _priceController.text = (packageData['price'] as num).toString();
          });
        }
      }
    } catch (e) {
      print('Error fetching package details: $e');
    }
  }

  Future<void> updatePackage() async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref('packages');

    try {
      // Prepare the updated package data
      Map<String, dynamic> updatedPackageData = {
        'category_name': selectedCategory,
        'start_date': DateFormat('yyyy-MM-dd').format(startDate!),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate!),
        'facilities': _facilitiesController.text.split(',').map((e) => e.trim()).toList(),
        'total_days': int.parse(_totalDaysController.text),
        'package_name': _packageNameController.text,
        'description': _packageDescriptionController.text,
        'price': double.parse(_priceController.text),
      };

      // Update the package in the database
      await _databaseReference.child(widget.packageId).update(updatedPackageData);

      // Show success dialog
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
                Text(
                  "Package Updated Successfully!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error updating package: $e');
      // Optionally show an error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Packages'),
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
              // Display packageId with black color and large font size
              Text(
                'Package ID: ${widget.packageId}',
                style: TextStyle(
                  color: Colors.black, // Set text color to black
                  fontSize: 24, // Set font size to large
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Choose Category
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

              // Add Image
              Text("Add Image"),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.6,
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
                    icon: Icon(Icons.upload_file),
                    label: Text('Choose file'),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Package Name
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

              // Package Description
              Text("Package Description"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _packageDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Package Description',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Start Date
              Text("Start Date"),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: startDate != null
                      ? DateFormat('yyyy-MM-dd').format(startDate!)
                      : 'Select Start Date',
                ),
               onTap: () async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: startDate != null && startDate!.isAfter(DateTime(2000))
        ? startDate!
        : DateTime.now(),  // Default to today if invalid
    firstDate: DateTime(2000),  // Minimum date allowed
    lastDate: DateTime(2100),  // Maximum date allowed
  );
  if (pickedDate != null) {
    setState(() {
      startDate = pickedDate;
    });
  }
},

              ),
              SizedBox(height: screenHeight * 0.03),

              // End Date
              Text("End Date"),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: endDate != null
                      ? DateFormat('yyyy-MM-dd').format(endDate!)
                      : 'Select End Date',
                ),
                onTap: () async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: endDate != null && endDate!.isAfter(DateTime(2000))
        ? endDate!
        : DateTime.now(),  // Default to today if invalid
    firstDate: DateTime(2000),  // Minimum date allowed
    lastDate: DateTime(2100),  // Maximum date allowed
  );
  if (pickedDate != null) {
    setState(() {
      endDate = pickedDate;
    });
  }
},

              ),
              SizedBox(height: screenHeight * 0.03),

              // Total Days
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

              // Facilities
              Text("Facilities"),
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _facilitiesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Facilities (comma-separated)',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Price
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
              SizedBox(height: screenHeight * 0.05),

              // Update Package Button
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
                  onPressed: () {
                    updatePackage(); // Call the update function
                  },
                  child: Text("Update Package"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
