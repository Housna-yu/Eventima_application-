import 'package:flutter/material.dart';
// For social media icons
import '../models/venue.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  VenueCard({
    required this.venue,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(venue.location, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Text('Contacts: ${venue.contacts}'),
            SizedBox(height: 4),
            Text('Available Time: ${venue.availableTime}'),
            SizedBox(height: 4),
            Text('Price: \$${venue.pricePerHour.toStringAsFixed(2)} per hour'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
                if (onDelete != null)
                  IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
