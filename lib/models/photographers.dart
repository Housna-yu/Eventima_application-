class Photographer {
  final String id;
  final String name;
  final String location;
  final String contacts;
  final List<String> portfolio;
  final String availableTime;
  final double pricePerHour;
  final String bio;

  Photographer({
    required this.id,
    required this.name,
    required this.location,
    required this.contacts,
    required this.portfolio,
    required this.availableTime,
    required this.pricePerHour,
    required this.bio,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'contacts': contacts,
      'portfolio': portfolio,
      'availableTime': availableTime,
      'pricePerHour': pricePerHour,
      'bio': bio,
    };
  }

  factory Photographer.fromFirestore(Map<String, dynamic> data, String id) {
    return Photographer(
      id: id,
      name: data['name'],
      location: data['location'],
      contacts: data['contacts'],
      portfolio: List<String>.from(data['portfolio'] ?? []),
      availableTime: data['availableTime'],
      pricePerHour: data['pricePerHour'],
      bio: data['bio'],
    );
  }
}
