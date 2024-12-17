import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/photographers.dart';

class PhotographerCard extends StatelessWidget {
  final Photographer photographer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  PhotographerCard(
      {required this.photographer,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              photographer.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Location: ${photographer.location}"),
            Text("Contacts: ${photographer.contacts}"),
            Text("Available Time: ${photographer.availableTime}"),
            Text("Price per Hour: \$${photographer.pricePerHour}"),
            Text("Bio: ${photographer.bio}"),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: photographer.portfolio.map((url) {
                return Image.network(url,
                    width: 100, height: 100, fit: BoxFit.cover);
              }).toList(),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  child: Text("Edit"),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
