class Venue {
  String id;
  String name;
  String location;
  String contacts;
  Map<String, String> socialMedia;
  String availableTime;
  double pricePerHour;
  List<String> images;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.contacts,
    required this.socialMedia,
    required this.availableTime,
    required this.pricePerHour,
    required this.images,
  });

  // Factory method to create a Venue from Firestore document
  factory Venue.fromFirestore(Map<String, dynamic> data, String id) {
    return Venue(
      id: id,
      name: data['name'],
      location: data['location'],
      contacts: data['contacts'],
      socialMedia: Map<String, String>.from(data['socialMedia']),
      availableTime: data['availableTime'],
      pricePerHour: data['pricePerHour'],
      images: List<String>.from(data['images']),
    );
  }

  // Method to convert Venue to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'contacts': contacts,
      'socialMedia': socialMedia,
      'availableTime': availableTime,
      'pricePerHour': pricePerHour,
      'images': images,
    };
  }
}
