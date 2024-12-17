import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotographerRequestForm extends StatefulWidget {
  final String serviceProviderId;

  PhotographerRequestForm({required this.serviceProviderId});
  @override
  _PhotographerRequestFormState createState() =>
      _PhotographerRequestFormState();
}

class _PhotographerRequestFormState extends State<PhotographerRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
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

  File? _uploadedId;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  DateTime? _startDate;
  DateTime? _endDate;

  // Gender selection
  String selectedGender = 'Both'; // Default value

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
        final String serviceProviderId = widget.serviceProviderId;

        // Data to save in Firestore
        final Map<String, dynamic> data = {
          'companyName': companyNameController.text.trim(),
          'ownerName': ownerNameController.text.trim(),
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
          'genderPreference': selectedGender,
          'images': _selectedImages.map((image) => image.path).toList(),
          'price': priceController.text.trim(),
          'location': locationController.text.trim(),
          'termsAndConditions': termsController.text.trim(),
          'accountNumber': accountNumberController.text.trim(),
          'uploadedId': _uploadedId?.path,
          'status': 'pending',
          'staffCount': staffCountController.text.trim(),
        };

        // Add a new document to the photographer_requests subcollection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(serviceProviderId)
            .collection('photographer_requests')
            .add(data);

        // Reset form and state
        _formKey.currentState!.reset();
        setState(() {
          _selectedImages.clear();
          _uploadedId = null;
          _startDate = null;
          _endDate = null;
          selectedGender = 'Both';
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
        title: Text('Photographer Request Form'),
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
                  'assets/image.png', // Replace with your logo path
                  height: 60,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Company Name', companyNameController),
              _buildTextField('Owner Full Name', ownerNameController),
              Text(
                'Upload ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildUploadId(),
              _buildTextField('License Folder Link', licensesController),
              _buildTextField('Location', locationController),
              _buildDateSelector(),
              _buildTextField(
                'Description',
                descriptionController,
                maxLines: 5,
              ),
              _buildTextField('Business Email', businessEmailController),
              _buildTextField('Facebook', facebookController),
              _buildTextField('Instagram', instagramController),
              _buildTextField('X (Twitter)', xController),
              _buildGenderSelector(),
              _buildTextField('Price', priceController),
              _buildTextField('Number of Staff', staffCountController),
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

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender Preference',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: ['Male', 'Female', 'Both']
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
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
