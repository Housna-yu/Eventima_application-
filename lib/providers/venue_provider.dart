import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/venue_service.dart';
import '../models/venue.dart';

class VenueProvider with ChangeNotifier {
  final VenueService _venueService = VenueService();

  List<Venue> _venues = [];

  List<Venue> get venues => _venues;

  Future<String> uploadImage(File image) async {
    try {
      String filePath =
          'venues/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      await FirebaseStorage.instance.ref(filePath).putFile(image);
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  Future<void> fetchVenues() async {
    _venues = await _venueService.fetchVenues();
    notifyListeners();
  }

  Future<void> addVenue(Venue venue) async {
    await _venueService.addVenue(venue);
    await fetchVenues(); // Refresh the list after adding
  }

  Future<void> updateVenue(Venue venue) async {
    await _venueService.updateVenue(venue);
    await fetchVenues(); // Refresh the list after updating
  }

  Future<void> deleteVenue(String venueId) async {
    await _venueService.deleteVenue(venueId);
    await fetchVenues(); // Refresh the list after deletion
  }
}
