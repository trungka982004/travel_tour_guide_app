import 'package:flutter/material.dart';
import '../data/room_booking_db_helper.dart';
import '../models/room_booking.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<BookingOrder> _bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _loadBookingHistory();
  }

  Future<void> _loadBookingHistory() async {
    final bookings = await RoomBookingDbHelper().getAllBookings();
    setState(() {
      _bookingHistory = bookings;
    });
  }

  Future<void> _saveHistory() async {
    // No-op: all changes are persisted immediately in the DB
  }

  void _confirmPayment(String orderId) async {
    await RoomBookingDbHelper().updateBookingStatus(orderId, 'paid');
    await _loadBookingHistory();
  }

  void _deleteOrder(String orderId) async {
    await RoomBookingDbHelper().deleteBooking(orderId);
    await _loadBookingHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đặt phòng', style: TextStyle(color: Colors.white)),
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
        child: _bookingHistory.isEmpty
            ? Center(
                child: Text(
                  'Chưa có đơn đặt phòng nào.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF01579B)),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _bookingHistory.length,
                itemBuilder: (context, index) {
                  final order = _bookingHistory[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Color(0xFFD1E8F1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order.roomName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                              if (order.status == 'paid')
                                IconButton(
                                  icon: Icon(Icons.delete, color: Color(0xFFFF5722)),
                                  onPressed: () => _deleteOrder(order.id),
                                )
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Mã đơn: ${order.id}', style: TextStyle(color: Color(0xFF01579B))),
                          Text('Khách: ${order.guestName}', style: TextStyle(color: Color(0xFF01579B))),
                          Text('Nhận phòng: ${order.checkIn.day}/${order.checkIn.month}/${order.checkIn.year}', style: TextStyle(color: Color(0xFF01579B))),
                          Text('Trả phòng: ${order.checkOut.day}/${order.checkOut.month}/${order.checkOut.year}', style: TextStyle(color: Color(0xFF01579B))),
                          Text('Người lớn: ${order.adults}, Trẻ em: ${order.children}', style: TextStyle(color: Color(0xFF01579B))),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Trạng thái: ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                              Text(
                                order.status == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán',
                                style: TextStyle(
                                  color: order.status == 'paid' ? Color(0xFF4CAF50) : Color(0xFFFF9800),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (order.status == 'unpaid') ...[
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _confirmPayment(order.id),
                              child: Text('Xác nhận thanh toán'),
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}