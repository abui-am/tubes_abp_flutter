class Seat {
  final int id;
  final int eventId;
  final String seatNo;
  final String seatType;
  final int? userId;
  final int isPaid;

  Seat({
    required this.id,
    required this.eventId,
    required this.seatNo,
    required this.seatType,
    this.userId,
    required this.isPaid,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      eventId: json['concert_id'],
      seatNo: json['seat_no'],
      seatType: json['seat_type'],
      userId: json['user_id'],
      isPaid: json['is_paid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat_id': id,
      'concert_id': eventId,
      'seat_no': seatNo,
      'seat_type': seatType,
      'user_id': userId,
      'is_paid': isPaid,
    };
  }
}
