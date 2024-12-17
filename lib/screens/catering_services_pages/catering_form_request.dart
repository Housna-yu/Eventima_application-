import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CateringRequestForm extends StatefulWidget {
  final String serviceProviderid;

  CateringRequestForm({required this.serviceProviderid});

  @override
  _CateringRequestFormState createState() => _CateringRequestFormState();
}

class _CateringRequestFormState extends State<CateringRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController licensesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController foodCategoriesController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController termsController = TextEditingController();

  File? _uploadedId;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  DateTime? _startDate;
  DateTime? _endDate;

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

        final Map<String, dynamic> data = {
          'company_name': companyNameController.text.trim(),
          'owner_full_name': ownerNameController.text.trim(),
          'license': licensesController.text.trim(),
          'available_time': _startDate != null && _endDate != null
              ? '${_startDate!.toIso8601String()} - ${_endDate!.toIso8601String()}'
              : 'N/A',
          'description': descriptionController.text.trim(),
          'business_email': businessEmailController.text.trim(),
          'social_media_accounts': {
            'Instagram': instagramController.text.trim(),
            'X': xController.text.trim(),
            'facebook': facebookController.text.trim(),
          },
          'food_category': foodCategoriesController.text.trim(),
          'price': priceController.text.trim(),
          'location': locationController.text.trim(),
          'terms_conditions': termsController.text.trim(),
          'account_number': accountNumberController.text.trim(),
          'images': _selectedImages.map((image) => image.path).toList(),
          'status': 'pending',
          'service_provider_id': widget.serviceProviderid,
          'catering_user_id': user.uid,
        };

        // Save request in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.serviceProviderid ??
                "H") // Path to the service provider's document
            .collection('catering_requests')
            .add(data);

        // Reset form and state
        _formKey.currentState!.reset();
        setState(() {
          _selectedImages.clear();
          _uploadedId = null;
          _startDate = null;
          _endDate = null;
        });

        _showSnackBar('Request submitted successfully!');
      } catch (e) {
        _showSnackBar('Error submitting request: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catering Request Form'),
        backgroundColor: Colors.purple.shade800,
      ),
      backgroundColor: Colors.purple.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/image.png',
                  height: 60,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Business Name', companyNameController),
              _buildTextField('Owner Name', ownerNameController),
              Text(
                'Upload Business ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildUploadId(),
              _buildTextField('License Folder Link', licensesController),
              _buildTextField('Location', locationController),
              _buildDateSelector(),
              _buildTextField(
                'Business Description',
                descriptionController,
                maxLines: 5,
              ),
              _buildTextField('Email Address', businessEmailController),
              _buildTextField('Facebook Profile', facebookController),
              _buildTextField('Instagram Profile', instagramController),
              _buildTextField('X (Twitter) Profile', xController),
              _buildTextField('Menu Category', foodCategoriesController),
              _buildTextField('Price Range', priceController),
              _buildTextField(
                'Terms and Conditions',
                termsController,
                maxLines: 5,
              ),
              _buildTextField('Account Number', accountNumberController),
              SizedBox(height: 20),
              Text(
                'Upload Images',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildImagePicker(),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple.shade400),
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
          label: Text('Add Image'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.purple.shade400),
          ),
        ),
      ],
    );
  }
}
