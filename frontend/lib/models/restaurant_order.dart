import 'dart:convert';

class RestaurantOrder {
  final String id;
  final List<Map<String, dynamic>> items;
  bool isPaid;

  RestaurantOrder({
    required this.id,
    required this.items,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'items': jsonEncode(items),
        'isPaid': isPaid ? 1 : 0,
      };

  factory RestaurantOrder.fromMap(Map<String, dynamic> map) => RestaurantOrder(
        id: map['id'],
        items: List<Map<String, dynamic>>.from(jsonDecode(map['items'])),
        isPaid: (map['isPaid'] ?? 0) == 1,
      );
} 