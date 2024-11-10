import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {
  final int price;
   final String packageId;

   const BookingForm({Key? key, required this.packageId, required this.price}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  int numberOfPeople = 1;
  bool agreeTerms = false;
  String? userId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _loadUserIdAndFetchUserData();
    _setCurrentDate();
  }

  Future<void> _setCurrentDate() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    dateController.text = formattedDate;
    print("Current date set to: $formattedDate"); // Debug print statement
  }

  Future<void> _loadUserIdAndFetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id');

    if (userId != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final snapshot = await _databaseReference.child('users/$userId').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          nameController.text = data['username'] ?? '';
          emailController.text = data['email'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    nameController.dispose();
    emailController.dispose();
    dateController.dispose();
    super.dispose();
  }

void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  // Extract the payment details
  String paymentMethod = response.paymentId ?? 'Unknown';
  String paymentStatus = 'Paid';

  // Generate a unique booking ID
  String bookingId = _databaseReference.child('bookings').push().key!;

  // Prepare the booking data to be added
  Map<String, dynamic> bookingData = {
    'booking_id': bookingId,
    'user_id': userId, // Assuming the userId is available
    'package_id': widget.packageId, // Add the package_id from the previous screen
    'no_of_people': numberOfPeople,
    'booking_date': dateController.text,
    'amount': widget.price * numberOfPeople,
    'payment_type': paymentMethod, // Payment method (e.g., Razorpay)
    'payment_status': paymentStatus,
  };

  try {
    // Save the booking data in the Firebase Realtime Database
    await _databaseReference.child('bookings').child(bookingId).set(bookingData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful! Booking has been saved.")),
    );
    Navigator.pop(context); // Close the booking screen
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving booking: $e")),
    );
  }
}
 

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet selected: ${response.walletName}")),
    );
  }

  void _startPayment() {
    int amount = numberOfPeople * widget.price * 100; // Convert to paise

    var options = {
      'key': 'rzp_test_AQWJhTr5CGLwF2',
      'amount': amount,
      'name': 'Travenour App',
      'description': 'Booking Payment',
      'prefill': {
        'contact': '8888888888',
        'email': emailController.text,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  readOnly: true, // Make it read-only
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of people',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      setState(() => numberOfPeople = int.parse(value)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: agreeTerms,
                      onChanged: (value) => setState(() => agreeTerms = value!),
                    ),
                    const Expanded(child: Text('Agree to terms and conditions')),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (agreeTerms) {
                          _startPayment();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You must agree to the terms')),
                          );
                        }
                      }
                    },
                    child: const Text('Book'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
