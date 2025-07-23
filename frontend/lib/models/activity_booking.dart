class ActivityBooking {
  final int? id;
  final int activityId;
  final String userEmail;
  final String bookingTime;
  final String status;
  final String bookingDate;
  final int numberOfPeople;

  ActivityBooking({
    this.id,
    required this.activityId,
    required this.userEmail,
    required this.bookingTime,
    this.status = 'booked',
    required this.bookingDate,
    required this.numberOfPeople,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'user_email': userEmail,
      'booking_time': bookingTime,
      'status': status,
      'booking_date': bookingDate,
      'number_of_people': numberOfPeople,
    };
  }

  factory ActivityBooking.fromMap(Map<String, dynamic> map) {
    return ActivityBooking(
      id: map['id'],
      activityId: map['activity_id'],
      userEmail: map['user_email'],
      bookingTime: map['booking_time'],
      status: map['status'],
      bookingDate: map['booking_date'],
      numberOfPeople: map['number_of_people'],
    );
  }
} 