class Room {
  final String name;
  final String imageAsset;
  final String size;
  final String capacity;
  final String bed;
  final String description;
  final List<String> amenities;

  Room({
    required this.name,
    required this.imageAsset,
    required this.size,
    required this.capacity,
    required this.bed,
    required this.description,
    required this.amenities,
  });
}

final List<Room> allRooms = [
  Room(
    name: 'Deluxe Room Garden View',
    imageAsset: 'assets/rooms/deluxe-room-garden-view.jpg',
    size: '45 m2',
    capacity: '2 Người lớn & 1 Trẻ dưới 5',
    bed: '1 Giường đôi / 2 Giường đơn',
    description: 'Thiết kế hiện đại, ban công thoáng, view sân vườn, ánh sáng tự nhiên, cảm giác thư thái an yên.',
    amenities: [
      '40" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Ban công riêng', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Máy sấy tóc', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Deluxe Bungalow Pool View',
    imageAsset: 'assets/rooms/deluxe-bungalow-pool-view.jpg',
    size: '60 m2',
    capacity: '2 Người lớn & 1 Trẻ dưới 5',
    bed: '1 Giường King',
    description: 'Bungalow riêng tư, sát hồ bơi, sân hiên rộng, giường King, mini-bar miễn phí.',
    amenities: [
      '50" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Máy sấy tóc', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Deluxe Bungalow Beach Front',
    imageAsset: 'assets/rooms/deluxe-bungalow-beach-front.jpg',
    size: '60 m2',
    capacity: '2 Người lớn & 1 Trẻ dưới 5',
    bed: '1 Giường King',
    description: 'Bungalow sát biển, không gian thoáng, view biển tuyệt đẹp, mini-bar miễn phí.',
    amenities: [
      '50" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Premium Bungalow Pool View',
    imageAsset: 'assets/rooms/premium-bungalow-pool-view.jpg',
    size: '80 m2',
    capacity: '2 Người lớn & 1 Trẻ dưới 5',
    bed: '1 Giường King',
    description: 'Bungalow cao cấp, sát hồ bơi, sân hiên riêng, bồn tắm Jacuzzi, sofa sang trọng.',
    amenities: [
      '55" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Premium Bungalow Beach Front',
    imageAsset: 'assets/rooms/premium-bungalow-beach-front.jpg',
    size: '80 m2',
    capacity: '2 Người lớn & 1 Trẻ dưới 5',
    bed: '1 Giường King',
    description: 'Bungalow sát biển, view đại dương, bồn tắm cao cấp, không gian nghỉ dưỡng tuyệt vời.',
    amenities: [
      '55" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Family Suite Sea View',
    imageAsset: 'assets/rooms/family-suite-sea-view.png',
    size: '105 m2',
    capacity: '4 Người lớn & 2 Trẻ dưới 5',
    bed: '1 King Bed / 2 Twin Beds',
    description: 'Suite gia đình, view biển, sofa tiếp khách, bồn Jacuzzi ngoài trời, mini-bar miễn phí.',
    amenities: [
      '55" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Không hút thuốc',
    ],
  ),
  Room(
    name: 'Family Suite Beach Front',
    imageAsset: 'assets/rooms/family-suite-beach-front.png',
    size: '150 m2',
    capacity: '4 Người lớn & 2 Trẻ dưới 5',
    bed: '1 Giường King / 2 Giường đơn',
    description: 'Suite gia đình sát biển, diện tích lớn nhất, không gian tinh tế, view biển và hồ bơi.',
    amenities: [
      '55" TV/HD', 'Điều hòa', 'Ăn sáng', 'Phòng tắm riêng', 'Bồn tắm Jacuzzi', 'Wifi', 'Mini Bar', 'Két an toàn', 'Tủ quần áo', 'Không hút thuốc',
    ],
  ),
]; 