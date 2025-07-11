import 'package:flutter/material.dart';
import '../widgets/quick_support_button.dart';

class ExcursionsScreen extends StatefulWidget {
  @override
  State<ExcursionsScreen> createState() => _ExcursionsScreenState();
}

class _ExcursionsScreenState extends State<ExcursionsScreen> {
  bool showExcursionsError = false;
  bool showDetailsError = false;
  List<Map<String, dynamic>> excursions = [
    {
      'title': 'Tour Vũng Tàu',
      'date': '15/07/2025',
      'time': '08:00',
      'available': true,
      'desc': 'Tour tham quan Vũng Tàu, bao gồm hướng dẫn viên.'
    },
    {
      'title': 'Tour đảo Long Sơn',
      'date': '16/07/2025',
      'time': '09:00',
      'available': false,
      'desc': 'Tour khám phá đảo Long Sơn.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excursions'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Danh sách tour/hoạt động ngoài trời', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            if (showExcursionsError)
              Row(
                children: [
                  Expanded(child: Text('Không tải được tour, thử lại', style: TextStyle(color: Colors.red))),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Color(0xFF1976D2)),
                    onPressed: () => setState(() => showExcursionsError = false),
                  ),
                ],
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: excursions.length,
                  itemBuilder: (context, i) {
                    final e = excursions[i];
                    return Card(
                      color: Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(Icons.map, color: Color(0xFF1976D2)),
                        title: Text('${e['title']}, ${e['date']}, ${e['time']}${e['available'] ? ', còn' : ', hết'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => _showDetails(context, e),
                              child: Text('Xem chi tiết'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: e['available'] ? () => _bookExcursion(context, e) : null,
                              child: Text('Đặt ngay'),
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
          ],
        ),
      ),
      floatingActionButton: QuickSupportButton(
        onPressed: () => _showSupportDialog(context),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> excursion) {
    if (showDetailsError) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi tải chi tiết'),
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
        title: Text(excursion['title']),
        content: Text(excursion['desc'] ?? 'Không có mô tả.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: excursion['available'] ? () {
              Navigator.pop(context);
              _bookExcursion(context, excursion);
            } : null,
            child: Text('Đặt ngay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1976D2),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _bookExcursion(BuildContext context, Map<String, dynamic> excursion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đi tới Đặt phòng/Dịch vụ với ${excursion['title']}')), 
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