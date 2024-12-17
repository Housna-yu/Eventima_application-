import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/photographers.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PhotographerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch all photographers
  Future<List<Photographer>> fetchPhotographers() async {
    final snapshot = await _db.collection('photographers').get();
    return snapshot.docs.map((doc) {
      return Photographer.fromFirestore(
          doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Add a new photographer
  Future<void> addPhotographer(Photographer photographer) async {
    await _db.collection('photographers').add(photographer.toFirestore());
  }

  // Update an existing photographer
  Future<void> updatePhotographer(Photographer photographer) async {
    await _db
        .collection('photographers')
        .doc(photographer.id)
        .update(photographer.toFirestore());
  }

  // Delete a photographer
  Future<void> deletePhotographer(String photographerId) async {
    await _db.collection('photographers').doc(photographerId).delete();
  }

  // Upload image to Firebase Storage and return the download URL
  Future<String> uploadImage(File image) async {
    String filePath =
        'photographers/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
    await _storage.ref(filePath).putFile(image);
    return await _storage.ref(filePath).getDownloadURL();
  }

  // Add image URL to photographer's portfolio
  Future<void> addImageToPortfolio(
      String photographerId, String imageUrl) async {
    DocumentReference photographerRef =
        _db.collection('photographers').doc(photographerId);
    await photographerRef.update({
      'portfolio': FieldValue.arrayUnion([imageUrl]),
    });
  }
}
