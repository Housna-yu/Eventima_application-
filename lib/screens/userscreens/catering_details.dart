import 'package:flutter/material.dart';

class CateringDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;

  CateringDetailsPage({required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(request['company_name']),
        backgroundColor: Colors.purple.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Name: ${request['company_name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Owner: ${request['owner_full_name']}'),
            SizedBox(height: 10),
            Text('Location: ${request['location']}'),
            SizedBox(height: 10),
            Text('Available Time: ${request['available_time']}'),
            SizedBox(height: 10),
            Text('Email: ${request['business_email']}'),
            SizedBox(height: 10),
            Text('Price: ${request['price']}'),
            SizedBox(height: 10),
            Text('Food Category: ${request['food_category']}'),
            SizedBox(height: 10),
            Text(
              'Description: ${request['description']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            _buildImageGallery(request['images']),
            SizedBox(height: 20),
            Text('Terms and Conditions: ${request['terms_conditions']}'),
            SizedBox(height: 10),
            _buildSocialMediaLinks(request['social_media_accounts']),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(List<dynamic> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: images.map((url) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Image.network(url, height: 200, fit: BoxFit.cover),
        );
      }).toList(),
    );
  }

  Widget _buildSocialMediaLinks(Map<String, dynamic> socialMedia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Social Media:'),
        SizedBox(height: 5),
        Text('Instagram: ${socialMedia['Instagram']}'),
        Text('X (Twitter): ${socialMedia['X']}'),
        Text('Facebook: ${socialMedia['facebook']}'),
      ],
    );
  }
}
