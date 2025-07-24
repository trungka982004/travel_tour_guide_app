class BookingOrder {
  final String id;
  final String roomName;
  final String roomImageAsset;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final String guestName;
  String status; // 'unpaid' or 'paid'

  BookingOrder({
    required this.id,
    required this.roomName,
    required this.roomImageAsset,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.guestName,
    this.status = 'unpaid',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'roomName': roomName,
        'roomImageAsset': roomImageAsset,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'adults': adults,
        'children': children,
        'guestName': guestName,
        'status': status,
      };

  factory BookingOrder.fromMap(Map<String, dynamic> map) => BookingOrder(
        id: map['id'],
        roomName: map['roomName'],
        roomImageAsset: map['roomImageAsset'],
        checkIn: DateTime.parse(map['checkIn']),
        checkOut: DateTime.parse(map['checkOut']),
        adults: map['adults'],
        children: map['children'],
        guestName: map['guestName'],
        status: map['status'] ?? 'unpaid',
      );
} 