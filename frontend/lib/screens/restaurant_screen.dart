import 'package:flutter/material.dart';
import '../widgets/quick_support_button.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  String selectedFilter = 'Tất cả';
  String selectedSort = 'Gần nhất';
  bool showRestaurantsError = false;
  bool showMenuError = false;
  bool showOrderError = false;
  List<Map<String, dynamic>> restaurants = [
    {
      'type': 'Hải sản',
      'name': 'Blue Sea',
      'hours': '11:00-22:00',
      'available': true,
      'menu': [
        {'dish': 'Cá nướng', 'price': '150.000 VNĐ'},
        {'dish': 'Tôm hấp', 'price': '200.000 VNĐ'},
      ],
    },
    {
      'type': 'Buffet',
      'name': 'Sunset Buffet',
      'hours': '18:00-21:00',
      'available': false,
      'menu': [
        {'dish': 'Buffet tối', 'price': '300.000 VNĐ'},
      ],
    },
    {
      'type': 'Cà phê',
      'name': 'Garden Cafe',
      'hours': '07:00-22:00',
      'available': true,
      'menu': [
        {'dish': 'Cà phê sữa', 'price': '40.000 VNĐ'},
      ],
    },
  ];
  List<Map<String, dynamic>> order = [];
  List<String> filters = ['Tất cả', 'Hải sản', 'Buffet', 'Cà phê'];
  List<String> sorts = ['Gần nhất', 'Phổ biến'];

  List<Map<String, dynamic>> get filteredRestaurants {
    if (selectedFilter == 'Tất cả') return restaurants;
    return restaurants.where((r) => r['type'] == selectedFilter).toList();
  }

  void _showMenu(BuildContext context, Map<String, dynamic> restaurant) {
    if (showMenuError) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi tải thực đơn'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Đóng'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thực đơn - ${restaurant['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (restaurant['menu'] as List).map((item) => Text('${item['dish']}: ${item['price']}')).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _bookTable(BuildContext context, Map<String, dynamic> restaurant) {
    if (!restaurant['available']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hết bàn, chọn giờ khác')),
      );
      return;
    }
    // Simulate booking form
    showDialog(
      context: context,
      builder: (context) {
        String? time;
        String? people;
        String? location;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Đặt bàn - ${restaurant['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: time,
                  hint: Text('Chọn giờ'),
                  items: ['11:00', '12:00', '19:00', '20:00'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setState(() => time = v),
                ),
                DropdownButtonFormField<String>(
                  value: people,
                  hint: Text('Số người'),
                  items: ['2 người', '4 người', '6 người'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (v) => setState(() => people = v),
                ),
                DropdownButtonFormField<String>(
                  value: location,
                  hint: Text('Vị trí'),
                  items: ['Trong nhà', 'Ngoài trời'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => location = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: (time != null && people != null && location != null)
                    ? () {
                        setState(() {
                          order.add({
                            'restaurant': restaurant['name'],
                            'time': time,
                            'people': people,
                            'location': location,
                          });
                        });
                        Navigator.pop(context);
                      }
                    : null,
                child: Text('Thêm vào đơn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editOrder(int index) {
    final item = order[index];
    // For simplicity, just remove and let user re-add
    setState(() => order.removeAt(index));
  }

  void _deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa mục này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() => order.removeAt(index));
              Navigator.pop(context);
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _confirmOrder() {
    if (order.isEmpty) {
      setState(() => showOrderError = true);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt bàn thành công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: order.map((item) => Text('${item['restaurant']}, ${item['time']}, ${item['people']}, ${item['location']}')).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => order.clear());
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Quay lại Trang chủ'),
          ),
        ],
      ),
    );
  }

  void _clearOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hủy tất cả?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Không'),
          ),
          TextButton(
            onPressed: () {
              setState(() => order.clear());
              Navigator.pop(context);
            },
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhà hàng'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter & Sort Bar
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: selectedFilter == f,
                          onSelected: (_) => setState(() => selectedFilter = f),
                          selectedColor: Color(0xFF1976D2),
                          labelStyle: TextStyle(color: selectedFilter == f ? Colors.white : Color(0xFF1976D2)),
                          backgroundColor: Color(0xFFF5F7FA),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedSort,
                  items: sorts.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => selectedSort = v!),
                  underline: SizedBox(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Restaurant List
            if (showRestaurantsError)
              Row(
                children: [
                  Expanded(child: Text('Không tải được nhà hàng, thử lại', style: TextStyle(color: Colors.red))),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Color(0xFF1976D2)),
                    onPressed: () => setState(() => showRestaurantsError = false),
                  ),
                ],
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, i) {
                    final r = filteredRestaurants[i];
                    return Card(
                      color: Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(Icons.restaurant, color: Color(0xFF1976D2)),
                        title: Text('${r['name']}, ${r['hours']}, ${r['available'] ? 'còn' : 'hết'}'),
                        subtitle: Text(r['type']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => _showMenu(context, r),
                              child: Text('Xem thực đơn'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: r['available'] ? () => _bookTable(context, r) : null,
                              child: Text('Đặt bàn'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                minimumSize: Size(80, 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 24),
            // Order Summary
            Text('Đơn đặt của bạn', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Expanded(
              child: order.isEmpty
                  ? Opacity(
                      opacity: 0.5,
                      child: Center(child: Text('Chưa có mục nào trong đơn.')),
                    )
                  : ListView.builder(
                      itemCount: order.length,
                      itemBuilder: (context, i) {
                        final item = order[i];
                        return Card(
                          color: Color(0xFFF5F7FA),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Icon(Icons.restaurant, color: Color(0xFF1976D2)),
                            title: Text('${item['restaurant']}, ${item['time']}, ${item['people']}, ${item['location']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () => _editOrder(i),
                                  tooltip: 'Sửa',
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteOrder(i),
                                  tooltip: 'Xóa',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (showOrderError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Đơn trống, vui lòng thêm mục.', style: TextStyle(color: Colors.red)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: order.isNotEmpty ? _confirmOrder : null,
                  child: Text('Xác nhận'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    minimumSize: Size(120, 40),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: order.isNotEmpty ? _clearOrder : null,
                  child: Text('Hủy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: Size(100, 40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: QuickSupportButton(
        onPressed: () => _showSupportDialog(context),
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hỗ trợ'),
        content: Text('Chức năng hỗ trợ sẽ được cập nhật sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
} 