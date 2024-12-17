import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingFormPage extends StatefulWidget {
  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  String? fullName;
  String? idNumber;
  String? date;
  String? venueName;
  bool specialServices = false;
  bool isVip = false;
  String? paymentMethod;
  List<String> services = [];

  // List of options for Dropdown and Checkboxes
  final List<String> paymentMethods = ["Cash", "Credit Card", "Bank Transfer"];
  final List<String> availableServices = [
    "Photography",
    "Catering",
    "Decor",
    "Security",
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save form data to Firestore
      FirebaseFirestore.instance.collection("booking_requests").add({
        "full_name": fullName,
        "id_number": idNumber,
        "date": date,
        "venue_name": venueName,
        "special_services": specialServices,
        "is_vip": isVip,
        "payment_method": paymentMethod,
        "services": services,
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking request submitted!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking Form")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                TextFormField(
                  decoration: InputDecoration(labelText: "Full Name"),
                  onSaved: (value) => fullName = value,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your full name" : null,
                ),
                SizedBox(height: 10),

                // ID Number
                TextFormField(
                  decoration: InputDecoration(labelText: "ID Number"),
                  onSaved: (value) => idNumber = value,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your ID number" : null,
                ),
                SizedBox(height: 10),

                // Date
                TextFormField(
                  decoration: InputDecoration(labelText: "Date"),
                  onSaved: (value) => date = value,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the date" : null,
                ),
                SizedBox(height: 10),

                // Venue Name
                TextFormField(
                  decoration: InputDecoration(labelText: "Venue Name"),
                  onSaved: (value) => venueName = value,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the venue name" : null,
                ),
                SizedBox(height: 10),

                // Special Services Checkbox
                CheckboxListTile(
                  title: Text("Special Services"),
                  value: specialServices,
                  onChanged: (value) {
                    setState(() {
                      specialServices = value!;
                    });
                  },
                ),

                // VIP Checkbox
                CheckboxListTile(
                  title: Text("VIP"),
                  value: isVip,
                  onChanged: (value) {
                    setState(() {
                      isVip = value!;
                    });
                  },
                ),

                // Payment Method Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Payment Method"),
                  items: paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a payment method" : null,
                ),

                // Services Checklist
                Text("Services:"),
                ...availableServices.map((service) {
                  return CheckboxListTile(
                    title: Text(service),
                    value: services.contains(service),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          services.add(service);
                        } else {
                          services.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Submit Booking Request"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
