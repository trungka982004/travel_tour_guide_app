import 'dart:convert';

class ServiceOrder {
  final String id;
  final List<Map<String, dynamic>> items;
  final String date;

  ServiceOrder({
    required this.id,
    required this.items,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'items': jsonEncode(items),
        'date': date,
      };

  factory ServiceOrder.fromMap(Map<String, dynamic> map) => ServiceOrder(
        id: map['id'],
        items: List<Map<String, dynamic>>.from(jsonDecode(map['items'])),
        date: map['date'],
      );
} 