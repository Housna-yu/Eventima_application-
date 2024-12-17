import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/photogrpher_service.dart';
import 'package:flutter_application_1/models/photographers.dart';

class PhotographerProvider with ChangeNotifier {
  final PhotographerService _photographerService = PhotographerService();
  List<Photographer> _photographers = [];

  List<Photographer> get photographers => _photographers;

  // Fetch photographers
  Future<List<Photographer>> fetchPhotographers() async {
    _photographers = await _photographerService.fetchPhotographers();
    notifyListeners();
    return _photographers; // Return the list of photographers
  }

  Future<void> addPhotographer(Photographer photographer) async {
    await _photographerService.addPhotographer(photographer);
    await fetchPhotographers(); // Refresh the list
  }

  Future<void> updatePhotographer(Photographer photographer) async {
    await _photographerService.updatePhotographer(photographer);
    await fetchPhotographers(); // Refresh the list
  }

  Future<void> deletePhotographer(String photographerId) async {
    await _photographerService.deletePhotographer(photographerId);
    await fetchPhotographers(); // Refresh the list
  }

  Future<String> uploadImage(File image) async {
    return await _photographerService.uploadImage(image);
  }

  Future<void> addImageToPortfolio(
      String photographerId, String imageUrl) async {
    await _photographerService.addImageToPortfolio(photographerId, imageUrl);
  }
}
