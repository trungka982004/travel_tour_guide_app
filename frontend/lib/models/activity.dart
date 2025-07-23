class Activity {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String category;
  final String time;
  final String audience;
  final String location;

  Activity({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.time,
    required this.audience,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'time': time,
      'audience': audience,
      'location': location,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      category: map['category'],
      time: map['time'],
      audience: map['audience'],
      location: map['location'],
    );
  }
} 