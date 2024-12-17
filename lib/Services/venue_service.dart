import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/venue.dart';
import 'dart:io';

class VenueService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Venue>> fetchVenues() async {
    try {
      final snapshot = await _db.collection('venues').get();
      return snapshot.docs
          .map((doc) =>
              Venue.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching venues: $e");
      return [];
    }
  }

  Future<void> addVenue(Venue venue) async {
    await _db.collection('venues').add(venue.toFirestore());
  }

  Future<void> updateVenue(Venue venue) async {
    await _db.collection('venues').doc(venue.id).update(venue.toFirestore());
  }

  Future<void> deleteVenue(String venueId) async {
    await _db.collection('venues').doc(venueId).delete();
  }

  Future<String> uploadImage(File image) async {
    try {
      String filePath =
          'venues/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      await _storage.ref(filePath).putFile(image);
      String downloadURL = await _storage.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }
}
