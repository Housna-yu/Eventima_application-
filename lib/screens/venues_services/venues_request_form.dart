import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VenuesRequestForm extends StatefulWidget {
  final String serviceProviderId;

  VenuesRequestForm({required this.serviceProviderId});

  @override
  _VenuesRequestFormState createState() => _VenuesRequestFormState();
}

class _VenuesRequestFormState extends State<VenuesRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController licensesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController termsController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController staffCountController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  File? _uploadedId;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> uploadId() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedId = File(pickedFile.path);
      });
    }
  }

  Future<void> selectDateRange() async {
    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedRange != null) {
      setState(() {
        _startDate = selectedRange.start;
        _endDate = selectedRange.end;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          _showSnackBar('You must be logged in to submit a request.');
          return;
        }

        // Get service provider ID (use the authenticated user's UID or pass it explicitly)
        // Data to save in Firestore
        final Map<String, dynamic> data = {
          'venueName': venueNameController.text.trim(),
          'ownerFullName': ownerNameController.text.trim(),
          'capacity': capacityController.text.trim(),
          'licenseLink': licensesController.text.trim(),
          'availableTime': {
            'start': _startDate?.toIso8601String(),
            'end': _endDate?.toIso8601String(),
          },
          'description': descriptionController.text.trim(),
          'businessEmail': businessEmailController.text.trim(),
          'socialMediaAccounts': {
            'Facebook': facebookController.text.trim(),
            'Instagram': instagramController.text.trim(),
            'X': xController.text.trim(),
          },
          'images': _selectedImages.map((image) => image.path).toList(),
          'price': priceController.text.trim(),
          'location': locationController.text.trim(),
          'termsAndConditions': termsController.text.trim(),
          'accountNumber': accountNumberController.text.trim(),
          'status': 'pending',
          'numberOfStaff': staffCountController.text.trim(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.serviceProviderId)
            .collection('venues_requests')
            .add(data);

        // Reset form and state
        _formKey.currentState!.reset();
        setState(() {
          _selectedImages.clear();
          _uploadedId = null;
          _startDate = null;
          _endDate = null;
        });

        _showSnackBar('Venue request submitted successfully!');
      } catch (e) {
        _showSnackBar('Error submitting request: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venue Request Form'),
        backgroundColor: Colors.teal.shade800,
      ),
      backgroundColor: Colors.teal.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Venue Name', venueNameController),
              _buildTextField('Owner Full Name', ownerNameController),
              _buildTextField('Capacity', capacityController),
              _buildTextField('License Link', licensesController),
              _buildDateSelector(),
              _buildTextField('Description', descriptionController,
                  maxLines: 5),
              _buildTextField('Business Email', businessEmailController),
              _buildTextField('Facebook Profile', facebookController),
              _buildTextField('Instagram Profile', instagramController),
              _buildTextField('X (Twitter) Profile', xController),
              _buildTextField('Price', priceController),
              _buildTextField('Location', locationController),
              _buildTextField('Terms and Conditions', termsController,
                  maxLines: 5),
              _buildTextField('Account Number', accountNumberController),
              _buildTextField('Number of Staff', staffCountController),
              _buildUploadId(),
              _buildImagePicker(),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text('Submit Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: selectDateRange,
          icon: Icon(Icons.calendar_today),
          label: Text(_startDate != null && _endDate != null
              ? '${_startDate!.toLocal()} - ${_endDate!.toLocal()}'
              : 'Select Date Range'),
        ),
      ],
    );
  }

  Widget _buildUploadId() {
    return Column(
      children: [
        _uploadedId != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _uploadedId!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : SizedBox.shrink(),
        OutlinedButton.icon(
          onPressed: uploadId,
          icon: Icon(Icons.upload_file),
          label: Text('Upload ID'),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _selectedImages
              .map((image) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: pickImage,
          icon: Icon(Icons.add_photo_alternate),
          label: Text('Add Images'),
        ),
      ],
    );
  }
}
