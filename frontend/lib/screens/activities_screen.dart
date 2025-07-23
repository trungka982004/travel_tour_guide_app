import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../data/activity_data.dart';
import '../data/activity_db_helper.dart';
import 'package:intl/intl.dart';
import '../models/activity_booking.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Activity> _displayedActivities = activities;
  String _selectedCategory = 'Tất cả';
  String _selectedTime = 'Tất cả';
  String _selectedAudience = 'Tất cả';
  Activity? _selectedActivity;
  bool _showDetail = false;
  bool _isBooking = false;
  String? _bookingStatus;
  bool _showAll = false;
  int _activityCardClicks = 0;
  String _searchText = '';
  List<ActivityBooking> _bookings = [];

  // Filter state
  String _filterCategory = 'Tất cả';
  String _filterTime = 'Tất cả';
  String _filterAudience = 'Tất cả';

  final List<String> _categories = ['Tất cả', 'Thể thao', 'Thư giãn', 'Văn hóa', 'Ẩm thực', 'Mua sắm'];
  final List<String> _times = ['Tất cả', 'Sáng', 'Trưa', 'Chiều', 'Tối'];
  final List<String> _audiences = ['Tất cả', 'Trẻ em', 'Gia đình', 'Cặp đôi', 'Người lớn', 'Mọi lứa tuổi'];
  final List<String> _feedbacks = [
    '“Buổi yoga cực chill.” – Minh Tr.',
    '“Bé nhà mình mê lớp vẽ tranh cát.” – Thảo N.',
    '“Dịch vụ rất tốt, nhân viên thân thiện.” – Hùng P.',
    '“Không gian xanh mát, nhiều hoạt động cho trẻ.” – Lan V.',
    '“Spa thư giãn tuyệt vời!” – Quang D.',
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final db = ActivityDbHelper();
    final userEmail = 'test@example.com';
    final bookingMaps = await db.getBookingsByUser(userEmail);
    setState(() {
      _bookings = bookingMaps.map((e) => ActivityBooking.fromMap(e)).toList();
    });
  }

  Future<void> _showBookingDialog(Activity activity) async {
    DateTime? selectedDate;
    int numberOfPeople = 1;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void handleBooking() async {
              if (selectedDate != null) {
                try {
                  final now = DateTime.now().toIso8601String();
                  await ActivityDbHelper().bookActivity(
                    activityId: activity.id!,
                    userEmail: 'test@example.com',
                    bookingTime: now,
                    bookingDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
                    numberOfPeople: numberOfPeople,
                  );
                  Navigator.of(context).pop();
                  await _loadBookings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đặt lịch thành công!')),
                  );
                } catch (e, stack) {
                  print('Booking error: $e\n$stack');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đặt lịch thất bại: $e')),
                  );
                }
              }
            }
            return AlertDialog(
              title: Text('Đặt lịch cho ${activity.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(selectedDate == null ? 'Chọn ngày' : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: now.add(Duration(days: 365)),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                  Row(
                    children: [
                      Text('Số người: '),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: numberOfPeople > 1 ? () => setState(() => numberOfPeople--) : null,
                      ),
                      Text('$numberOfPeople'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => numberOfPeople++),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: selectedDate != null ? handleBooking : null,
                  child: Text('Đặt lịch'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F7FA),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1976D2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Hoạt động', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCenterControl(),
            _buildBookingsList(),
            Expanded(
              child: _buildActivityList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Danh sách hoạt động', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
              if (_displayedActivities.length > 8)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showAll = !_showAll;
                      });
                    },
                    child: Text(_showAll ? 'Thu gọn' : 'Xem thêm', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text('Khám phá các trải nghiệm tuyệt vời dành cho mọi lứa tuổi tại Carmelina!', style: TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCenterControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm hoạt động...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF1976D2)),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchText = val;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt, color: Color(0xFF1976D2)),
            tooltip: 'Bộ lọc',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Bộ lọc hoạt động', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _filterCategory = 'Tất cả';
                                _filterTime = 'Tất cả';
                                _filterAudience = 'Tất cả';
                              });
                              Navigator.of(context).pop();
                            },
                            tooltip: 'Xóa bộ lọc',
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildFilterDropdown('Thể loại', _filterCategory, _categories, (val) {
                        setState(() {
                          _filterCategory = val ?? 'Tất cả';
                        });
                      }),
                      SizedBox(height: 12),
                      _buildFilterDropdown('Thời gian', _filterTime, _times, (val) {
                        setState(() {
                          _filterTime = val ?? 'Tất cả';
                        });
                      }),
                      SizedBox(height: 12),
                      _buildFilterDropdown('Đối tượng', _filterAudience, _audiences, (val) {
                        setState(() {
                          _filterAudience = val ?? 'Tất cả';
                        });
                      }),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {}); // Just to trigger rebuild
                              Navigator.of(context).pop();
                            },
                            child: Text('Áp dụng'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.reviews, color: Color(0xFF1976D2)),
            tooltip: 'Đánh giá',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Đánh giá nổi bật'),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _feedbacks.map((f) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(f, style: TextStyle(fontStyle: FontStyle.italic)),
                        )).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.event_note, color: Color(0xFF1976D2)),
            tooltip: 'Lịch trình của tôi',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Lịch trình của tôi'),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text('Tính năng quản lý lịch trình sẽ được phát triển ở đây.'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Container(width: 90, child: Text(label)),
        SizedBox(width: 12),
        Expanded(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Color(0xFF1976D2), size: 28),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF1976D2), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBookingsList() {
    if (_bookings.isEmpty) {
      return SizedBox.shrink();
    }
    final latestBooking = _bookings.last;
    final activity = activities.firstWhere((a) => a.id == latestBooking.activityId, orElse: () => activities[0]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Hoạt động đã đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1976D2))),
              SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Lịch sử đơn đặt'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _bookings.reversed.map((b) {
                              final act = activities.firstWhere((a) => a.id == b.activityId, orElse: () => activities[0]);
                              return Card(
                                child: ListTile(
                                  leading: Image.asset(act.image, width: 40, height: 40, fit: BoxFit.cover),
                                  title: Text(act.name),
                                  subtitle: Text('Ngày: ${b.bookingDate}\nSố người: ${b.numberOfPeople}'),
                                  trailing: Text(b.status, style: TextStyle(color: Colors.green)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Lịch sử đơn đặt'),
              ),
            ],
          ),
          Card(
            child: ListTile(
              leading: Image.asset(activity.image, width: 48, height: 48, fit: BoxFit.cover),
              title: Text(activity.name),
              subtitle: Text('Ngày: ${latestBooking.bookingDate}\nSố người: ${latestBooking.numberOfPeople}'),
              trailing: Text(latestBooking.status, style: TextStyle(color: Colors.green)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    final filtered = activities.where((a) {
      final matchCategory = _filterCategory == 'Tất cả' || a.category == _filterCategory;
      final matchTime = _filterTime == 'Tất cả' || a.time.contains(_filterTime);
      final matchAudience = _filterAudience == 'Tất cả' || a.audience.contains(_filterAudience);
      final matchSearch = _searchText.isEmpty || a.name.toLowerCase().contains(_searchText.toLowerCase());
      return matchCategory && matchTime && matchAudience && matchSearch;
    }).toList();
    final activitiesToShow = _showAll || filtered.length <= 8
        ? filtered
        : filtered.sublist(0, 8);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: activitiesToShow.length,
      itemBuilder: (context, idx) {
        final activity = activitiesToShow[idx];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _buildActivityDetailDialog(activity),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(activity.image, width: 80, height: 80, fit: BoxFit.cover),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(activity.time, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityDetailDialog(Activity activity) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(activity.image, width: double.infinity, height: 180, fit: BoxFit.cover),
                ),
                SizedBox(height: 12),
                Text(activity.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
                SizedBox(height: 8),
                Text(activity.description, style: TextStyle(fontSize: 15)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.place, size: 18, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.location)),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 18, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.time)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.group, size: 18, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.audience)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _showBookingDialog(activity);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Đặt lịch'),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF1976D2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Đóng', style: TextStyle(color: Color(0xFF1976D2))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _displayedActivities = activities.where((a) {
        final matchCategory = _selectedCategory == 'Tất cả' || a.category == _selectedCategory;
        final matchTime = _selectedTime == 'Tất cả' || a.time.contains(_selectedTime);
        final matchAudience = _selectedAudience == 'Tất cả' || a.audience.contains(_selectedAudience);
        final matchSearch = _searchText.isEmpty || a.name.toLowerCase().contains(_searchText.toLowerCase());
        return matchCategory && matchTime && matchAudience && matchSearch;
      }).toList();
      _showAll = false;
    });
  }
} 