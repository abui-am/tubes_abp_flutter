class Concert {
  final int id;
  final String title;
  final String artists;
  final DateTime date;
  final String city;
  final String venue;
  final String venueAddress;
  final int ticketPriceInRupiah;
  final String videoURL;
  final String imageURL;
  final String additionalInformation;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Concert({
    required this.id,
    required this.title,
    required this.artists,
    required this.date,
    required this.city,
    required this.venue,
    required this.venueAddress,
    required this.ticketPriceInRupiah,
    required this.videoURL,
    required this.imageURL,
    required this.additionalInformation,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id'],
      title: json['title'],
      artists: json['artists'],
      date: DateTime.parse(json['date']),
      city: json['city'],
      venue: json['venue'],
      venueAddress: json['venue_address'],
      ticketPriceInRupiah: json['ticket_price_in_rupiah'],
      videoURL: json['videoURL'],
      imageURL: json['imageURL'],
      additionalInformation: json['additional_information'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artists': artists,
      'date': date.toIso8601String(),
      'city': city,
      'venue': venue,
      'venue_address': venueAddress,
      'ticket_price_in_rupiah': ticketPriceInRupiah,
      'videoURL': videoURL,
      'imageURL': imageURL,
      'additional_information': additionalInformation,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
