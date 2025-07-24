import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/excursion_db_helper.dart';
import '../models/excursion_booking.dart';
import '../data/user_db_helper.dart';
import '../models/user.dart';

class ExcursionsScreen extends StatefulWidget {
  @override
  State<ExcursionsScreen> createState() => _ExcursionsScreenState();
}

class _ExcursionsScreenState extends State<ExcursionsScreen> {
  final List<Map<String, dynamic>> excursions = [
    {
      'id': 0,
      'title': 'Chùa Hòn Một',
      'desc': 'Khám phá vẻ đẹp hoang sơ của đảo Hòn Một và ngôi chùa.',
      'image': 'assets/excursions/hon-mot.png',
      'distance': 'Khoảng cách 25 km',
      'details': 'Ghé thăm chùa Hòn Một, linh hồn của Hồ Tràm, nơi có khung cảnh bình dị làm nổi bật những ngôi đền, các bức tượng và vườn cây cảnh đẹp mắt. Vì chùa nằm ở vị trí thuận tiện cách Phủ Thạch Hầu chỉ 5 phút, nên khách du lịch có thể tham gia tour quanh Núi Minh Đàm và khám phá tất cả những địa điểm này trong vòng một ngày.',
      'rating': 5,
    },
    {
      'id': 1,
      'title': 'Khu bảo tồn thiên nhiên Bình Châu – Phước Bửu',
      'desc': 'Dạo bước giữa thiên nhiên đa dạng tại khu bảo tồn.',
      'image': 'assets/excursions/phuc-buu.png',
      'distance': 'Khoảng cách 6 km',
      'details': 'Chỉ cách Khu Nghỉ Dưỡng 9 phút đi xe, Khu bảo tồn thiên nhiên Bình Châu – Phước Bửu tự hào là một trong những khu rừng nguyên sinh ven biển duy nhất còn sót lại ở Việt Nam với diện tích hơn 10.000 hecta và là nơi quy tụ hệ thực vật phong phú cùng một số loài động vật quý hiếm.',
      'rating': 4,
    },
    {
      'id': 2,
      'title': 'Suối nước nóng Bình Châu',
      'desc': 'Thư giãn tại suối nước nóng và tắm bùn khoáng.',
      'image': 'assets/excursions/binh-chau.png',
      'distance': 'Khoảng cách 20 km',
      'details': 'Nằm cách Carmelina 25 phút lái xe ven biển về phía Bắc là Suối nước nóng Bình Châu, nổi tiếng với khu phức hợp bể bơi nước nóng và tắm bùn. Người ta tin rằng dòng nước suối nóng ở 37 ° C với hàm lượng khoáng chất cao có thể cải thiện lưu thông máu, thư giãn cơ bắp và làm dịu các dây thần kinh của bạn.',
      'rating': 5,
    },
    {
      'id': 3,
      'title': 'Núi Minh Đạm',
      'desc': 'Leo núi, khám phá hang động và rừng xanh.',
      'image': 'assets/excursions/minh-dam.png',
      'distance': 'Khoảng cách 33 km',
      'details': 'Ngọn núi Minh Đạm nằm cách Carmelina Beach Resort 45 phút di chuyển, là một địa điểm lịch sử, căn cứ du kích trong thời chiến (1933 – 1975). Du khách có thể khám phá hệ thống hang động phức tạp, đan xen là những hồ nước tự nhiên mát lạnh hoặc đi dạo qua những khu rừng xanh mát và ngắm nhìn những chú khỉ tinh nghịch đu qua lại trên những tán cây cao phía trên.',
      'rating': 4,
    },
    {
      'id': 4,
      'title': 'Chùa Trúc Lâm Chân Nguyên',
      'desc': 'Gặp gỡ khỉ hoang dã và tận hưởng cảnh núi rừng.',
      'image': 'assets/excursions/monkey-moutaint.png',
      'distance': 'Khoảng cách 25 km',
      'details': 'Nằm dưới chân núi Minh Đàm, Phủ Thạch Hầu – ban đầu được gọi là Tu viện Trúc Lâm Chân Nguyên – là một ngôi chùa cổ duyên dáng được bao quanh bởi quang cảnh núi non tuyệt đẹp và khu rừng rộng lớn. Tại đây, bạn có thể chiêm ngưỡng từng nhóm hàng trăm chú khỉ quanh khu vực này như một nét độc đáo của tu viện.',
      'rating': 5,
    },
    {
      'id': 5,
      'title': 'Thành phố Vũng Tàu',
      'desc': 'Trải nghiệm thành phố biển sôi động và các bãi tắm nổi tiếng.',
      'image': 'assets/excursions/vung-tau-city.jpg',
      'distance': 'Khoảng cách 44 km',
      'details': 'Cách khu nghỉ dưỡng chưa đầy một giờ lái xe, Vũng Tàu là một thành phố nhộn nhịp cung cấp nhiều hoạt động cả ngày lẫn đêm. Bên cạnh đó, thành phố còn có những điểm tham quan nổi bật như: Tượng đài Chúa Kitô, Bạch Dinh, Hòn Bà, Hải đăng và tượng Phật Thích Ca Mâu Ni (Thích Ca Phật Đài). Carmelina cũng cung cấp phương tiện đi lại giúp bạn di chuyển thuận tiện từ khu nghỉ dưỡng đến Vũng Tàu.',
      'rating': 3,
    },
  ];

  List<ExcursionBooking> bookings = [];
  String currentUserEmail = '';
  bool showHistory = false; // This can be removed if not used elsewhere

  @override
  void initState() {
    super.initState();
    _loadUserAndBookings();
  }

  Future<void> _loadUserAndBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      setState(() {
        currentUserEmail = email;
      });
      final user = await UserDbHelper().getUserByEmail(email);
      if (user != null) {
        setState(() {
          // userFullName = user.fullName; // This line is removed
        });
      }
      await _loadBookings();
    }
  }

  Future<void> _loadBookings() async {
    final dbHelper = ExcursionDbHelper();
    final bookingMaps = await dbHelper.getBookingsByUser(currentUserEmail);
    setState(() {
      bookings = bookingMaps.map((map) => ExcursionBooking.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        title: Text('Excursions', style: TextStyle(color: Colors.white)),
        leading: BackButton(color: Colors.white),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookings.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  child: Text('Tour đã đặt', style: TextStyle(color: Color(0xFF01579B), fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Card(
                    color: Color(0xFFD1E8F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(Icons.event_available, color: Color(0xFF80DEEA)),
                      title: Text(_getExcursionTitleById(bookings.last.excursionId), style: TextStyle(color: Color(0xFF01579B))),
                      subtitle: Text(
                        'Tên: ${bookings.last.userName}\nEmail: ${bookings.last.userEmail}\nNgày: ${bookings.last.bookingDate.isNotEmpty ? _formatDate(bookings.last.bookingDate) : ''}\nKhách: ${bookings.last.numberOfPeople}\nDịch vụ: ${bookings.last.status}'
                      ),
                    ),
                  ),
                ),
                if (bookings.length > 1) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: GestureDetector(
                      onTap: () => _showHistoryDialog(context),
                      child: Row(
                        children: [
                          Text('Lịch sử đơn', style: TextStyle(color: Color(0xFF01579B), fontSize: 16, fontWeight: FontWeight.bold)),
                          Icon(Icons.history, color: Color(0xFF01579B)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
              SizedBox(height: 24),
              // Top Recommendation (Horizontal Scroll)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Top Recommendation', style: TextStyle(color: Color(0xFF01579B), fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 12),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: excursions.take(3).map((e) => _excursionCard(context, e, featured: true, showStars: true)).toList(),
                ),
              ),
              SizedBox(height: 24),
              // All Excursions (Grid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('All Excursions', style: TextStyle(color: Color(0xFF01579B), fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: excursions.map((e) => _excursionCard(context, e)).toList(),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _excursionCard(BuildContext context, Map<String, dynamic> e, {bool featured = false, bool showStars = false}) {
    return GestureDetector(
      onTap: () => _showDetails(context, e),
      child: Container(
        width: featured ? 260 : null,
        margin: featured ? EdgeInsets.only(right: 16) : null,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD1E8F1), Color(0xFF80DEEA)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          image: DecorationImage(
            image: AssetImage(e['image']!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.18), BlendMode.darken),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.10), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(e['title']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: featured ? 20 : 16, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
              if (showStars) ...[
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) => i < (e['rating'] ?? 5) ? Icon(Icons.star, color: Colors.amber, size: 18) : Icon(Icons.star_border, color: Colors.amber, size: 18)),
                ),
              ],
              SizedBox(height: 6),
              Text(e['desc']!, style: TextStyle(color: Colors.white, fontSize: featured ? 14 : 12, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> excursion) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          excursion['image'] as String,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.10), Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.place, color: Color(0xFF80DEEA)),
                    SizedBox(width: 6),
                    Text(excursion['distance'] as String? ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF80DEEA))),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  excursion['title'] as String,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF01579B)),
                ),
                SizedBox(height: 8),
                Text(
                  excursion['details'] as String? ?? excursion['desc'] as String,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close', style: TextStyle(color: Color(0xFF80DEEA), fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBookingSheet(context, excursion);
                        },
                        child: Text('Book Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF80DEEA),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getExcursionTitleById(int id) {
    final found = excursions.firstWhere((e) => e['id'] == id, orElse: () => {});
    return found['title'] ?? '';
  }

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showBookingSheet(BuildContext context, Map<String, dynamic> excursion) {
    DateTime? selectedDate;
    int guests = 1;
    List<String> extraServices = [];
    final List<String> allServices = ['Chăm sóc sức khỏe', 'Hướng dẫn viên', 'Đưa đón', 'Bữa ăn'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (context, setStateSheet) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text('Đặt tour', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                  SizedBox(height: 12),
                  Text('Tên tour: ${excursion['title']}', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Color(0xFF80DEEA)),
                      SizedBox(width: 8),
                      Text(
                        selectedDate == null
                          ? 'Chọn ngày bắt đầu'
                          : 'Ngày: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) setStateSheet(() => selectedDate = picked);
                        },
                        child: Text('Chọn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF80DEEA),
                          foregroundColor: Colors.white,
                          minimumSize: Size(60, 32),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, color: Color(0xFF80DEEA)),
                      SizedBox(width: 8),
                      Text('Số lượng khách:'),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: guests > 1 ? () => setStateSheet(() => guests--) : null,
                      ),
                      Text('	$guests', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setStateSheet(() => guests++),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Dịch vụ thêm:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Wrap(
                    spacing: 8,
                    children: allServices.map((service) => FilterChip(
                      label: Text(service),
                      selected: extraServices.contains(service),
                      onSelected: (selected) {
                        setStateSheet(() {
                          if (selected) {
                            extraServices.add(service);
                          } else {
                            extraServices.remove(service);
                          }
                        });
                      },
                    )).toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: selectedDate == null ? null : () async {
                          final dbHelper = ExcursionDbHelper();
                          final excursionId = excursion['id'];
                          // Fetch user name from user db
                          final prefs = await SharedPreferences.getInstance();
                          final email = prefs.getString('userEmail');
                          String userName = '';
                          if (email != null) {
                            final user = await UserDbHelper().getUserByEmail(email);
                            if (user != null) userName = user.fullName;
                          }
                          await dbHelper.bookExcursion(
                            excursionId: excursionId,
                            userEmail: currentUserEmail,
                            userName: userName,
                            bookingTime: DateTime.now().toIso8601String(),
                            bookingDate: selectedDate!.toIso8601String(),
                            numberOfPeople: guests,
                            status: extraServices.join(', '),
                          );
                          await _loadBookings();
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Đặt tour thành công!'),
                              content: Text('Bạn đã đặt tour thành công cho ${excursion['title']}.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Đóng'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Booking'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF80DEEA),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSupportDialogForBooking(BuildContext context, ExcursionBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hỗ trợ đặt tour'),
        content: Text(
          'Bạn cần hỗ trợ cho tour:\n'
          'Tên tour: ${_getExcursionTitleById(booking.excursionId)}\n'
          'Ngày: ${_formatDate(booking.bookingDate)}\n'
          'Khách: ${booking.numberOfPeople}\n'
          'Dịch vụ: ${booking.status}\n\n'
          'Bộ phận hỗ trợ sẽ liên hệ với bạn sớm nhất.'
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

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lịch sử đơn'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: bookings.map((b) => Card(
                color: Color(0xFFD1E8F1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Icon(Icons.event_available, color: Color(0xFF80DEEA)),
                  title: Text(_getExcursionTitleById(b.excursionId), style: TextStyle(color: Color(0xFF01579B))),
                  subtitle: Text(
                    'Tên: ${b.userName}\nEmail: ${b.userEmail}\nNgày: ${b.bookingDate.isNotEmpty ? _formatDate(b.bookingDate) : ''}\nKhách: ${b.numberOfPeople}\nDịch vụ: ${b.status}'
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.support_agent, color: Color(0xFF0288D1)),
                    tooltip: 'Yêu cầu hỗ trợ',
                    onPressed: () => _showSupportDialogForBooking(context, b),
                  ),
                ),
              )).toList(),
            ),
          ),
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
}