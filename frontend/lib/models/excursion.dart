class Excursion {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String location;
  final String time;
  final String category;

  Excursion({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.time,
    required this.category,
  });

  factory Excursion.fromMap(Map<String, dynamic> map) {
    return Excursion(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      location: map['location'],
      time: map['time'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'location': location,
      'time': time,
      'category': category,
    };
  }
} 