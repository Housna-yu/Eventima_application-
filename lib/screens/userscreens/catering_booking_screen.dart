import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/userscreens/catering_details.dart';

class CateringBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catering Booking'),
        backgroundColor: Colors.purple.shade800,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('serviceproviderId') // Replace with dynamic ID as needed
            .collection('catering_requests')
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Catering Services Available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final requests = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Display two cards per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8, // Adjust the height/width ratio
            ),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;
              return _buildCateringCard(context, request);
            },
          );
        },
      ),
    );
  }

  Widget _buildCateringCard(
      BuildContext context, Map<String, dynamic> request) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              request['images'][0], // Display the first image
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['company_name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Catering Company',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToDetailsPage(context, request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('View More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailsPage(
      BuildContext context, Map<String, dynamic> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CateringDetailsPage(request: request),
      ),
    );
  }
}
