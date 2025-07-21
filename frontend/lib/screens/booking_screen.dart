import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'booking_history_screen.dart';
import 'package:uuid/uuid.dart';
import '../data/room_data.dart';

class BookingScreen extends StatefulWidget {
  final Function(int) onBackToHome;
  BookingScreen({required this.onBackToHome});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0;
  Room? _selectedRoom;
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  int _children = 0;
  String _guestName = '';
  String _guestPhone = '';
  String _guestEmail = '';
  String _note = '';
  String _payment = 'Trả tại Resort';
  String _discountCode = '';
  String _typeFilter = 'Tất cả';
  String _bookingId = '';

  List<String> get _typeOptions {
    final types = allRooms.map((r) => r.name.split(' ')[0]).toSet().toList();
    types.sort();
    return ['Tất cả', ...types];
  }

  List<Room> get _filteredRooms {
    var rooms = allRooms;
    if (_typeFilter != 'Tất cả') {
      rooms = rooms.where((r) => r.name.startsWith(_typeFilter)).toList();
    }
    return rooms;
  }

  Future<void> _saveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final newOrder = BookingOrder(
      id: _bookingId,
      roomName: _selectedRoom!.name,
      roomImageAsset: _selectedRoom!.imageAsset,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      adults: _adults,
      children: _children,
      guestName: _guestName,
      status: 'unpaid', // Ensure new bookings are always unpaid initially
    );
    final history = prefs.getStringList('booking_history') ?? [];
    history.add(json.encode(newOrder.toJson()));
    await prefs.setStringList('booking_history', history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt Phòng', style: TextStyle(color: Colors.white)),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            if (_step == 3) {
              setState(() {
                _step = 0;
                _selectedRoom = null;
                _checkIn = null;
                _checkOut = null;
                _adults = 2;
                _children = 0;
                _guestName = '';
                _guestPhone = '';
                _guestEmail = '';
                _note = '';
                _payment = 'Trả tại Resort';
                _discountCode = '';
                _bookingId = '';
              });
            } else if (_step == 0) {
              widget.onBackToHome(0);
            } else {
              setState(() {
                _step = _step - 1;
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistoryScreen()),
              );
            },
          ),
        ],
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
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _buildStep(context),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildRoomList(context);
      case 1:
        return _buildRoomDetail(context);
      case 2:
        return _buildBookingForm(context);
      case 3:
        return _buildSuccess(context);
      default:
        return _buildRoomList(context);
    }
  }

  Widget _buildRoomList(BuildContext context) {
    return ListView(
      key: ValueKey(0),
      padding: EdgeInsets.all(16),
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Text('Bộ lọc: ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
            SizedBox(width: 8),
            DropdownButton<String>(
              value: _typeFilter,
              items: _typeOptions.map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(color: Color(0xFF01579B))))).toList(),
              onChanged: (v) => setState(() => _typeFilter = v ?? 'Tất cả'),
              hint: Text('Loại phòng', style: TextStyle(color: Color(0xFF01579B))),
              dropdownColor: Color(0xFFD1E8F1),
            ),
          ],
        ),
        SizedBox(height: 12),
        ..._filteredRooms.map((room) => Card(
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Color(0xFFD1E8F1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(room.imageAsset, height: 160, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF01579B))),
                        SizedBox(height: 4),
                        Text('${room.capacity} | ${room.size} | ${room.bed}', style: TextStyle(color: Colors.teal[700])),
                        SizedBox(height: 8),
                        Text(room.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedRoom = room;
                                  _step = 1;
                                });
                              },
                              child: Text('Xem chi tiết'),
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
                            ),
                            SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedRoom = room;
                                  _step = 2;
                                });
                              },
                              child: Text('Đặt ngay', style: TextStyle(color: Color(0xFF80DEEA))),
                              style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF80DEEA))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRoomDetail(BuildContext context) {
    final room = _selectedRoom!;
    return ListView(
      key: ValueKey(1),
      padding: EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(room.imageAsset, height: 220, width: double.infinity, fit: BoxFit.cover),
        ),
        SizedBox(height: 16),
        Text(room.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF01579B))),
        SizedBox(height: 8),
        Text('${room.size} | ${room.capacity} | ${room.bed}', style: TextStyle(color: Colors.teal[700])),
        SizedBox(height: 8),
        Text(room.description, style: TextStyle(color: Colors.grey[700])),
        SizedBox(height: 12),
        Text('Tiện nghi:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
        Wrap(
          spacing: 8,
          children: room.amenities.map((a) => Chip(label: Text(a, style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFF80DEEA))).toList(),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _step = 2;
                  });
                },
                child: Text('Đặt phòng'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _step = 0; // Go back to room list
                  });
                },
                child: Text('Quay lại', style: TextStyle(color: Color(0xFF80DEEA))),
                style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF80DEEA))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingForm(BuildContext context) {
    final room = _selectedRoom!;
    return ListView(
      key: ValueKey(2),
      padding: EdgeInsets.all(16),
      children: [
        Text('Thông Tin Đặt Phòng', style: TextStyle(color: Color(0xFF01579B), fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text(room.name, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _checkIn ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _checkIn = picked);
                },
                child: Text(_checkIn == null
                    ? 'Chọn ngày nhận phòng'
                    : 'Nhận phòng: ${_checkIn!.day}/${_checkIn!.month}/${_checkIn!.year}'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _checkOut ?? (_checkIn ?? DateTime.now()).add(Duration(days: 1)),
                    firstDate: _checkIn ?? DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                  );
                  if (picked != null) setState(() => _checkOut = picked);
                },
                child: Text(_checkOut == null
                    ? 'Chọn ngày trả phòng'
                    : 'Trả phòng: ${_checkOut!.day}/${_checkOut!.month}/${_checkOut!.year}'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _adults,
                decoration: InputDecoration(labelText: 'Người lớn', labelStyle: TextStyle(color: Color(0xFF01579B))),
                items: List.generate(5, (i) => i + 1)
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v', style: TextStyle(color: Color(0xFF01579B)))))
                    .toList(),
                onChanged: (v) => setState(() => _adults = v ?? 2),
                dropdownColor: Color(0xFFD1E8F1),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _children,
                decoration: InputDecoration(labelText: 'Trẻ em', labelStyle: TextStyle(color: Color(0xFF01579B))),
                items: List.generate(5, (i) => i)
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v', style: TextStyle(color: Color(0xFF01579B)))))
                    .toList(),
                onChanged: (v) => setState(() => _children = v ?? 0),
                dropdownColor: Color(0xFFD1E8F1),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextFormField(
          decoration: InputDecoration(labelText: 'Họ tên', labelStyle: TextStyle(color: Color(0xFF01579B))),
          onChanged: (v) => _guestName = v,
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(labelText: 'SĐT', labelStyle: TextStyle(color: Color(0xFF01579B))),
          keyboardType: TextInputType.phone,
          onChanged: (v) => _guestPhone = v,
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Color(0xFF01579B))),
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => _guestEmail = v,
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(labelText: 'Ghi chú', labelStyle: TextStyle(color: Color(0xFF01579B))),
          onChanged: (v) => _note = v,
        ),
        SizedBox(height: 12),
        Text('Thanh Toán:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                value: 'Trả tại Resort',
                groupValue: _payment,
                onChanged: (v) => setState(() => _payment = v!),
                title: Text('Trả tại Resort', style: TextStyle(color: Color(0xFF01579B))),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                value: 'Online',
                groupValue: _payment,
                onChanged: (v) => setState(() => _payment = v!),
                title: Text('Online', style: TextStyle(color: Color(0xFF01579B))),
              ),
            ),
          ],
        ),
        if (_payment == 'Online')
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text('VNPay / ZaloPay / MoMo', style: TextStyle(color: Color(0xFF01579B))),
              ],
            ),
          ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(labelText: 'Mã giảm giá', labelStyle: TextStyle(color: Color(0xFF01579B))),
          onChanged: (v) => _discountCode = v,
        ),
        SizedBox(height: 16),
        Card(
          color: Color(0xFFD1E8F1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tóm tắt đơn hàng:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                SizedBox(height: 4),
                Text('Phòng: ${room.name}', style: TextStyle(color: Color(0xFF01579B))),
                Text('Ngày: ' +
                    (_checkIn != null && _checkOut != null
                        ? '${_checkIn!.day}/${_checkIn!.month} - ${_checkOut!.day}/${_checkOut!.month}'
                        : 'Chưa chọn')),
                Text('Khách: $_adults NL + $_children TE'),
                Text('Tổng: ...'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: (_checkIn != null && _checkOut != null && _guestName.isNotEmpty && _guestPhone.isNotEmpty)
                    ? () {
                        setState(() {
                          _bookingId = Uuid().v4();
                          _step = 3;
                          _saveBooking();
                        });
                      }
                    : null,
                child: Text('Xác nhận đặt phòng'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _step = 1; // Go back to room detail
                  });
                },
                child: Text('Quay lại', style: TextStyle(color: Color(0xFF80DEEA))),
                style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF80DEEA))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final room = _selectedRoom!;
    return Center(
      key: ValueKey(3),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Color(0xFF80DEEA), size: 64),
            SizedBox(height: 16),
            Text('Đặt phòng thành công!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF01579B))),
            SizedBox(height: 8),
            Text('Mã đơn: $_bookingId', style: TextStyle(color: Color(0xFF01579B))),
            SizedBox(height: 8),
            Text('Thời gian: ' +
                (_checkIn != null && _checkOut != null
                    ? '${_checkIn!.day}/${_checkIn!.month} - ${_checkOut!.day}/${_checkOut!.month}'
                    : '')),
            Text('Phòng: ${room.name}', style: TextStyle(color: Color(0xFF01579B))),
            Text('Khách: $_adults NL + $_children TE'),
            SizedBox(height: 8),
            Text('Tổng tiền: ...'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _step = 0;
                  _selectedRoom = null;
                  _checkIn = null;
                  _checkOut = null;
                  _adults = 2;
                  _children = 0;
                  _guestName = '';
                  _guestPhone = '';
                  _guestEmail = '';
                  _note = '';
                  _payment = 'Trả tại Resort';
                  _discountCode = '';
                  _bookingId = '';
                });
              },
              child: Text('Trang chủ'),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF80DEEA), foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}