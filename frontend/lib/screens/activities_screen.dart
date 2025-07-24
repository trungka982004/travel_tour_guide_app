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
      builder: (context) => StatefulBuilder(
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
                  SnackBar(content: Text('Đặt lịch thành công!', style: TextStyle(color: Colors.white))),
                );
              } catch (e, stack) {
                print('Booking error: $e\n$stack');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đặt lịch thất bại: $e', style: TextStyle(color: Colors.white))),
                );
              }
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: EdgeInsets.all(16),
            title: Text('Đặt lịch cho ${activity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            content: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(selectedDate == null ? 'Chọn ngày' : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                    trailing: Icon(Icons.calendar_today, color: Color(0xFF01579B)),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Số người: ', style: TextStyle(color: Color(0xFF01579B))),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.remove, color: Color(0xFF01579B)),
                        onPressed: numberOfPeople > 1 ? () => setState(() => numberOfPeople--) : null,
                      ),
                      Text('$numberOfPeople', style: TextStyle(fontSize: 16, color: Color(0xFF01579B))),
                      IconButton(
                        icon: Icon(Icons.add, color: Color(0xFF01579B)),
                        onPressed: () => setState(() => numberOfPeople++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Hủy', style: TextStyle(color: Color(0xFF01579B))),
              ),
              ElevatedButton(
                onPressed: selectedDate != null ? handleBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF80DEEA),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Đặt lịch', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showRatingDialog(Activity activity) async {
    double _rating = 0;
    final TextEditingController _commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Đánh giá: ${activity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 5,
                label: _rating.toStringAsFixed(1),
                activeColor: Color(0xFF80DEEA),
                inactiveColor: Color(0xFFD1E8F1),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              Text('Đánh giá: ${_rating.toStringAsFixed(1)}/5', style: TextStyle(fontSize: 16, color: Color(0xFF01579B))),
              SizedBox(height: 12),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Nhận xét',
                  prefixIcon: Icon(Icons.comment, color: Color(0xFF01579B)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF80DEEA))),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy', style: TextStyle(color: Color(0xFF01579B))),
          ),
          ElevatedButton(
            onPressed: _rating > 0
                ? () {
                    // Logic lưu đánh giá (giả định)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đánh giá đã được gửi!', style: TextStyle(color: Colors.white))),
                    );
                    Navigator.of(context).pop();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF80DEEA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Gửi đánh giá', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Hoạt động', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0288D1), Color(0xFF00ACC1)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          ),
        ),
        child: SafeArea(
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
              Text('Danh sách hoạt động', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
              if (_displayedActivities.length > 8)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showAll = !_showAll;
                      });
                    },
                    child: Text(_showAll ? 'Thu gọn' : 'Xem thêm', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text('Khám phá các trải nghiệm tuyệt vời dành cho mọi lứa tuổi tại Carmelina!', style: TextStyle(fontSize: 16, color: Color(0xFF455A64))),
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
                color: Color(0xFFD1E8F1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm hoạt động...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF01579B)),
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
            icon: Icon(Icons.filter_alt, color: Color(0xFF01579B)),
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
                          Expanded(child: Text('Bộ lọc hoạt động', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B)))),
                          IconButton(
                            icon: Icon(Icons.clear, color: Color(0xFF01579B)),
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
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                            child: Text('Áp dụng', style: TextStyle(color: Colors.white)),
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
            icon: Icon(Icons.reviews, color: Color(0xFF01579B)),
            tooltip: 'Đánh giá',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Text('Đánh giá nổi bật', style: TextStyle(color: Color(0xFF01579B))),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _feedbacks.map((f) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(f, style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF455A64))),
                        )).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng', style: TextStyle(color: Color(0xFF01579B))),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.event_note, color: Color(0xFF01579B)),
            tooltip: 'Lịch trình của tôi',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Text('Lịch trình của tôi', style: TextStyle(color: Color(0xFF01579B))),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                      ),
                    ),
                    child: Text('Tính năng quản lý lịch trình sẽ được phát triển ở đây.', style: TextStyle(color: Color(0xFF455A64))),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng', style: TextStyle(color: Color(0xFF01579B))),
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
        Container(width: 90, child: Text(label, style: TextStyle(color: Color(0xFF01579B)))),
        SizedBox(width: 12),
        Expanded(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            style: TextStyle(color: Color(0xFF01579B)),
            dropdownColor: Color(0xFFD1E8F1),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Color(0xFF01579B))))).toList(),
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
              color: Color(0xFF80DEEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF80DEEA).withOpacity(0.5), width: 1),
            ),
            child: Icon(icon, color: Color(0xFF01579B), size: 28),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF01579B), fontWeight: FontWeight.w500)),
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
              Text('Hoạt động đã đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
              SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      title: Text('Lịch sử đơn đặt', style: TextStyle(color: Color(0xFF01579B))),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _bookings.reversed.map((b) {
                              final act = activities.firstWhere((a) => a.id == b.activityId, orElse: () => activities[0]);
                              return Card(
                                color: Color(0xFFD1E8F1),
                                child: ListTile(
                                  leading: Image.asset(act.image, width: 40, height: 40, fit: BoxFit.cover),
                                  title: Text(act.name, style: TextStyle(color: Color(0xFF01579B))),
                                  subtitle: Text('Ngày: ${b.bookingDate}\nSố người: ${b.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
                                  trailing: Text(b.status, style: TextStyle(color: Color(0xFF4CAF50))),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Đóng', style: TextStyle(color: Color(0xFF01579B))),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Lịch sử đơn đặt', style: TextStyle(color: Color(0xFF01579B))),
              ),
            ],
          ),
          Card(
            color: Color(0xFFD1E8F1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Image.asset(activity.image, width: 48, height: 48, fit: BoxFit.cover),
              title: Text(activity.name, style: TextStyle(color: Color(0xFF01579B))),
              subtitle: Text('Ngày: ${latestBooking.bookingDate}\nSố người: ${latestBooking.numberOfPeople}', style: TextStyle(color: Color(0xFF455A64))),
              trailing: Text(latestBooking.status, style: TextStyle(color: Color(0xFF4CAF50))),
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
      color: Color(0xFFD1E8F1),
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
                    Text(activity.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                    SizedBox(height: 4),
                    Text(activity.time, style: TextStyle(fontSize: 14, color: Color(0xFF455A64))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF01579B)),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          ),
        ),
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
                Text(activity.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                SizedBox(height: 8),
                Text(activity.description, style: TextStyle(fontSize: 15, color: Color(0xFF455A64))),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.place, size: 18, color: Color(0xFF01579B)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.location, style: TextStyle(color: Color(0xFF455A64)))),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 18, color: Color(0xFF01579B)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.time, style: TextStyle(color: Color(0xFF455A64)))),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.group, size: 18, color: Color(0xFF01579B)),
                    SizedBox(width: 4),
                    Expanded(child: Text(activity.audience, style: TextStyle(color: Color(0xFF455A64)))),
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
                        backgroundColor: Color(0xFF80DEEA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Đặt lịch', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showRatingDialog(activity); // Thêm chức năng đánh giá sau khi đóng dialog chi tiết
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF80DEEA)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Đánh giá', style: TextStyle(color: Color(0xFF01579B))),
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