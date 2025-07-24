class ExcursionBooking {
  final int? id;
  final int excursionId;
  final String userEmail;
  final String userName;
  final String bookingTime;
  final String bookingDate;
  final int numberOfPeople;
  final String status;

  ExcursionBooking({
    this.id,
    required this.excursionId,
    required this.userEmail,
    required this.userName,
    required this.bookingTime,
    required this.bookingDate,
    required this.numberOfPeople,
    this.status = 'booked',
  });

  factory ExcursionBooking.fromMap(Map<String, dynamic> map) {
    return ExcursionBooking(
      id: map['id'],
      excursionId: map['excursion_id'],
      userEmail: map['user_email'],
      userName: map['user_name'] ?? '',
      bookingTime: map['booking_time'],
      bookingDate: map['booking_date'],
      numberOfPeople: map['number_of_people'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'excursion_id': excursionId,
      'user_email': userEmail,
      'user_name': userName,
      'booking_time': bookingTime,
      'booking_date': bookingDate,
      'number_of_people': numberOfPeople,
      'status': status,
    };
  }
} 