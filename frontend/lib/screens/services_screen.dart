import 'package:flutter/material.dart';
import '../widgets/quick_support_button.dart';

class ServicesScreen extends StatefulWidget {
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String selectedFilter = 'Tất cả';
  String selectedSort = 'Gần nhất';
  bool showServicesError = false;
  bool showOrderError = false;
  List<Map<String, dynamic>> services = [
    {
      'type': 'Đưa rước',
      'name': 'Đưa rước sân bay',
      'hours': '08:00-20:00',
      'available': true,
      'details': ['Xe 4 chỗ', 'Xe 7 chỗ'],
    },
    {
      'type': 'Bơi',
      'name': 'Bộ bơi nam',
      'hours': '08:00-18:00',
      'available': true,
      'details': ['Size M', 'Size L'],
    },
    {
      'type': 'Giặt ủi',
      'name': 'Dịch vụ giặt ủi',
      'hours': '09:00-17:00',
      'available': false,
      'details': ['Áo sơ mi', 'Quần dài'],
    },
  ];
  List<Map<String, dynamic>> order = [];
  List<String> filters = ['Tất cả', 'Đưa rước', 'Bơi', 'Giặt ủi'];
  List<String> sorts = ['Gần nhất', 'Phổ biến'];

  List<Map<String, dynamic>> get filteredServices {
    if (selectedFilter == 'Tất cả') return services;
    return services.where((s) => s['type'] == selectedFilter).toList();
  }

  void _addService(BuildContext context, Map<String, dynamic> service) {
    if (!service['available']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dịch vụ hết, chọn khác')),
      );
      return;
    }
    // Simulate add form
    showDialog(
      context: context,
      builder: (context) {
        String? detail;
        DateTime? date;
        TimeOfDay? time;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Thêm dịch vụ - ${service['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: detail,
                  hint: Text('Chi tiết'),
                  items: (service['details'] as List)
                      .map((d) => DropdownMenuItem<String>(value: d as String, child: Text(d as String)))
                      .toList(),
                  onChanged: (v) => setState(() => detail = v),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) setState(() => date = picked);
                  },
                  child: Text(date == null ? 'Chọn ngày' : '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => time = picked);
                  },
                  child: Text(time == null ? 'Chọn giờ' : time!.format(context)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: (detail != null && date != null && time != null)
                    ? () {
                        setState(() {
                          order.add({
                            'service': service['name'],
                            'detail': detail,
                            'date': date,
                            'time': time,
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
        title: Text('Đặt thành công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: order.map((item) => Text('${item['service']}, ${item['date'].day.toString().padLeft(2, '0')}/${item['date'].month.toString().padLeft(2, '0')}/${item['date'].year}, ${item['time'].format(context)}, ${item['detail']}')).toList(),
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
        title: Text('Dịch vụ'),
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
            // Service List
            if (showServicesError)
              Row(
                children: [
                  Expanded(child: Text('Không tải được dịch vụ, thử lại', style: TextStyle(color: Colors.red))),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Color(0xFF1976D2)),
                    onPressed: () => setState(() => showServicesError = false),
                  ),
                ],
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, i) {
                    final s = filteredServices[i];
                    return Card(
                      color: Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(Icons.directions_car, color: Color(0xFF1976D2)),
                        title: Text('${s['name']}, ${s['hours']}, ${s['available'] ? 'còn' : 'hết'}'),
                        subtitle: Text(s['type']),
                        trailing: ElevatedButton(
                          onPressed: s['available'] ? () => _addService(context, s) : null,
                          child: Text('Thêm vào đơn'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            minimumSize: Size(80, 32),
                          ),
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
                            leading: Icon(Icons.directions_car, color: Color(0xFF1976D2)),
                            title: Text('${item['service']}, ${item['date'].day.toString().padLeft(2, '0')}/${item['date'].month.toString().padLeft(2, '0')}/${item['date'].year}, ${item['time'].format(context)}, ${item['detail']}'),
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