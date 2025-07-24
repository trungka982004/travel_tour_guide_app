import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/restaurant_data.dart';
import '../data/restaurant_order_db_helper.dart';
import '../models/restaurant_order.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  String selectedFilter = 'Tất cả';
  String selectedSort = 'Gần nhất';
  bool showMenuError = false;
  bool showOrderError = false;
  List<RestaurantOrder> orderHistory = [];
  List<Map<String, dynamic>> currentOrder = [];

  List<String> sorts = ['Gần nhất', 'Phổ biến'];
  bool showFilters = false;
  String searchText = '';
  late ScrollController _scrollController;
  double _cardWidth = 160.0; // Default card width

  final Set<String> specialCuisineImages = {
    'assets/restaurant/seafood.png',
    'assets/restaurant/vietnam_cuisine.png',
    'assets/restaurant/western_cuisine.png',
  };

  List<Map<String, dynamic>> get filteredDishes {
    final lowerSearch = searchText.toLowerCase();
    return dishes.where((dish) {
      bool matchesFilter;
      switch (selectedFilter) {
        case 'Tất cả':
          matchesFilter = true;
          break;
        case 'Món chính':
          matchesFilter = dish['type'] != 'Tráng miệng' && dish['type'] != 'Rau củ';
          break;
        default:
          matchesFilter = dish['type'] == selectedFilter;
      }
      final matchesSearch = dish['name'].toString().toLowerCase().contains(lowerSearch) || dish['desc'].toString().toLowerCase().contains(lowerSearch);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _editOrder(int index) {
    final item = currentOrder[index];
    setState(() => currentOrder.removeAt(index));
  }

  Future<void> _deleteOrder(String id) async {
    await RestaurantOrderDbHelper().deleteOrder(id);
    await _loadOrdersFromDb();
  }

  void _confirmOrder() {
    if (currentOrder.isEmpty) {
      setState(() => showOrderError = true);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt bàn thành công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currentOrder.map((item) => Text('${item['restaurant']}, ${item['time']}, ${item['people']}, ${item['location']}')).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => currentOrder.clear());
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
              setState(() => currentOrder.clear());
              Navigator.pop(context);
            },
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    _loadOrdersFromDb();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_scrollController.hasClients) {
        double scrollAmount = _cardWidth + 16.0; // card width + margin
        double nextScrollPosition = _scrollController.offset + scrollAmount;
        if (nextScrollPosition >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(
            nextScrollPosition,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOrdersFromDb() async {
    final orders = await RestaurantOrderDbHelper().getAllOrders();
    setState(() {
      orderHistory = orders;
    });
  }

  Future<void> _saveCurrentOrderToDb() async {
    if (currentOrder.isNotEmpty) {
      final order = RestaurantOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List<Map<String, dynamic>>.from(currentOrder),
        isPaid: false,
      );
      await RestaurantOrderDbHelper().insertOrder(order);
      currentOrder.clear();
      await _loadOrdersFromDb();
    }
  }

  Future<void> _updateOrderPaid(String id) async {
    await RestaurantOrderDbHelper().updateOrderStatus(id, true);
    await _loadOrdersFromDb();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _cardWidth = (screenWidth / 2) - 24; // Calculate width for 2 cards with padding

    return Scaffold(
      appBar: AppBar(
        title: Text('Nhà hàng', style: TextStyle(color: Colors.white)),
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
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm món ăn...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF01579B)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng số đơn: ${orderHistory.length + (currentOrder.isNotEmpty ? 1 : 0)}',
                    style: TextStyle(color: Color(0xFF01579B), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHistoryScreen(
                          orderHistory: orderHistory,
                          onUpdate: _loadOrdersFromDb,
                        )),
                      );
                    },
                    child: Text(
                      'Chi tiết đơn đặt',
                      style: TextStyle(color: Color(0xFF0288D1), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (currentOrder.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFD1E8F1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentOrder.map((item) => '${item['restaurant']} x${item['quantity']}').join(', '),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tổng: ' + _getOrderTotalString(currentOrder),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700]),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (currentOrder.isNotEmpty) {
                              final newOrder = RestaurantOrder(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                items: List<Map<String, dynamic>>.from(currentOrder),
                                isPaid: false,
                              );
                              orderHistory.add(newOrder);
                              currentOrder.clear();
                            }
                          });
                          _saveCurrentOrderToDb();
                        },
                        child: Text('Xác nhận'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF80DEEA),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 16),
              Text('Ẩm thực đặc trưng', style: TextStyle(color: Color(0xFF01579B), fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _specialCuisineCard(dishes.firstWhere((d) => d['name'] == 'Seafood Platter'), width: _cardWidth),
                    _specialCuisineCard(dishes.firstWhere((d) => d['name'] == 'Vietnamese Cuisine'), width: _cardWidth),
                    _specialCuisineCard(dishes.firstWhere((d) => d['name'] == 'Western Cuisine'), width: _cardWidth),
                    _specialCuisineCard(dishes.firstWhere((d) => d['name'] == 'Seafood Platter'), width: _cardWidth), // Duplicate for seamless loop
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text('Tất cả món', style: TextStyle(color: Color(0xFF01579B), fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
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
                            selectedColor: Color(0xFF80DEEA),
                            labelStyle: TextStyle(color: selectedFilter == f ? Colors.white : Color(0xFF01579B)),
                            backgroundColor: Color(0xFF80DEEA).withOpacity(0.2),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: filteredDishes
                    .where((dish) => !specialCuisineImages.contains(dish['image']))
                    .map((dish) => _dishCardVertical(dish)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dishCardHorizontal(Map<String, dynamic> dish) {
    return GestureDetector(
      onTap: () => _showDishDetailDialog(dish),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD1E8F1), Color(0xFF80DEEA)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                dish['image'],
                height: 70,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dish['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF01579B))),
                  SizedBox(height: 2),
                  Row(
                    children: List.generate(5, (i) => i < (dish['rating'] ?? 5)
                        ? Icon(Icons.star, color: Colors.amber, size: 14)
                        : Icon(Icons.star_border, color: Colors.amber, size: 14)),
                  ),
                  SizedBox(height: 2),
                  Text(dish['price'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700], fontSize: 13)),
                  SizedBox(height: 2),
                  Text(dish['desc'], style: TextStyle(fontSize: 11, color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
  }

  Widget _dishCardVertical(Map<String, dynamic> dish) {
    return Card(
      color: Color(0xFFD1E8F1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            dish['image'],
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(dish['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dish['price'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700])),
            Text(dish['desc'], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: () => _showAddToOrderDialog(dish, (orderItem) {
            setState(() {
              currentOrder.add(orderItem);
            });
            _saveCurrentOrderToDb();
          }),
          child: Text('Thêm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF80DEEA),
            foregroundColor: Colors.white,
            minimumSize: Size(56, 36),
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }

  void _showAddToOrderDialog(Map<String, dynamic> dish, void Function(Map<String, dynamic>) onOrderAdd) {
    int quantity = 1;
    int unitPrice = int.tryParse(dish['price'].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          int totalPrice = unitPrice * quantity;
          String totalPriceStr = totalPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Thêm vào đơn', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Column(
                              mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dish['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                                ),
                      Text('$quantity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                IconButton(
                        icon: Icon(Icons.add),
                        onPressed: quantity < 20 ? () => setState(() => quantity++) : null,
                                ),
                              ],
                            ),
                  SizedBox(height: 12),
                  Text('Tổng: $totalPriceStr VNĐ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700], fontSize: 16)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onOrderAdd({
                    'restaurant': dish['name'],
                    'quantity': quantity,
                    'price': dish['price'],
                    'total': '$totalPriceStr VNĐ',
                    'time': '---',
                    'people': '---',
                    'location': '---',
                  });
                  print('[DEBUG] Order added: ${dish['name']} x$quantity');
                },
                  child: Text('Xác nhận'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF80DEEA),
                    foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDishDetailDialog(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(dish['name'], style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    dish['image'],
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: List.generate(5, (i) => i < (dish['rating'] ?? 5)
                      ? Icon(Icons.star, color: Colors.amber, size: 18)
                      : Icon(Icons.star_border, color: Colors.amber, size: 18)),
                ),
                SizedBox(height: 8),
                Text(dish['price'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700], fontSize: 16)),
                SizedBox(height: 8),
                Text(dish['desc'], style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
                ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookDishForm(dish);
            },
            child: Text('Đặt món ngay'),
                  style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF80DEEA),
                    foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookDishForm(Map<String, dynamic> dish) {
    int guests = 1;
    bool babyChair = false;
    bool extraNapkin = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Đặt món: ${dish['name']}', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Số khách: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: guests > 1 ? () => setState(() => guests--) : null,
                      ),
                      Text('$guests', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => guests++),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    value: babyChair,
                    onChanged: (v) => setState(() => babyChair = v ?? false),
                    title: Text('Ghế em bé'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    value: extraNapkin,
                    onChanged: (v) => setState(() => extraNapkin = v ?? false),
                    title: Text('Khăn ăn thêm'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentOrder.add({
                    'restaurant': dish['name'],
                    'time': '---',
                    'people': '$guests khách',
                    'location': '---',
                    'babyChair': babyChair,
                    'extraNapkin': extraNapkin,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Xác nhận'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF80DEEA),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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

  String _getOrderTotalString(List<Map<String, dynamic>> orderList) {
    int total = 0;
    for (final item in orderList) {
      final price = int.tryParse(item['price']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
      final qty = item['quantity'] ?? 1;
      total += (price * qty).toInt();
    }
    final totalStr = total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
    return '$totalStr VNĐ';
  }

  List<List<Map<String, dynamic>>> _getLatestOrders() {
    final List<List<Map<String, dynamic>>> result = [];
    if (currentOrder.isNotEmpty) {
      result.add(currentOrder);
    }
    
    final history = orderHistory.reversed.take(3 - result.length).toList().reversed.toList();
    
    result.addAll(history.map((orderData) => List<Map<String, dynamic>>.from(orderData.items)));
    
    return result;
  }

  int _getOrderNumber(int idx) {
    if (currentOrder.isNotEmpty) {
      if (idx == 0) return orderHistory.length + 1;
      return orderHistory.length - (orderHistory.length - idx + 1) + 1;
    } else {
      return orderHistory.length - (orderHistory.length - idx);
    }
  }

  void _showOrderDetailDialog(List<Map<String, dynamic>> orderList, bool isCurrent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Chi tiết đơn đặt', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...orderList.map((item) {
                  final dish = dishes.firstWhere((d) => d['name'] == item['restaurant'], orElse: () => <String, dynamic>{});
                  return Card(
                    color: Color(0xFFD1E8F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: dish.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                dish['image'],
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                      title: Text(item['restaurant'] + (item['quantity'] != null ? ' x${item['quantity']}' : ''), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                      subtitle: Text(item['total'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700])),
                    ),
                  );
                }).toList(),
                SizedBox(height: 8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng cộng:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(_getOrderTotalString(orderList), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700], fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          if (isCurrent)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (currentOrder.isNotEmpty) {
                    final newOrder = RestaurantOrder(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      items: List<Map<String, dynamic>>.from(currentOrder),
                      isPaid: false,
                    );
                    orderHistory.add(newOrder);
                    currentOrder.clear();
                  }
                });
                Navigator.pop(context);
              },
              child: Text('Xác nhận'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF80DEEA),
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _specialCuisineCard(Map<String, dynamic> dish, {required double width}) {
    return GestureDetector(
      onTap: () => _showSpecialCuisineDetail(dish),
      child: Container(
        width: width,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD1E8F1), Color(0xFF80DEEA)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                dish['image'],
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dish['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF01579B))),
                  SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) => i < (dish['rating'] ?? 5)
                        ? Icon(Icons.star, color: Colors.amber, size: 16)
                        : Icon(Icons.star_border, color: Colors.amber, size: 16)),
                  ),
                  SizedBox(height: 4),
                  Text(dish['desc'], style: TextStyle(fontSize: 12, color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpecialCuisineDetail(Map<String, dynamic> dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(dish['name'], style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  dish['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12),
              Text(cuisineInfo[dish['name']] ?? dish['desc'], style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadMenuPDF(dish['pdf']);
            },
            child: Text('Thực đơn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF80DEEA),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadMenuPDF(String pdfPath) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở file PDF: $pdfPath')),
    );
  }
}

class OrderHistoryScreen extends StatefulWidget {
  final List<RestaurantOrder> orderHistory;
  final Function onUpdate;

  const OrderHistoryScreen({Key? key, required this.orderHistory, required this.onUpdate}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn', style: TextStyle(color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.orderHistory.isEmpty
              ? Center(child: Text('Chưa có đơn nào.', style: TextStyle(color: Color(0xFF01579B))))
              : ListView.builder(
                  itemCount: widget.orderHistory.length,
                  itemBuilder: (context, i) {
                    final orderData = widget.orderHistory[i];
                    final orderItems = List<Map<String, dynamic>>.from(orderData.items);
                    final isPaid = orderData.isPaid;
                    
                    int total = 0;
                    for (final item in orderItems) {
                      final price = int.tryParse(item['price']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
                      final qty = item['quantity'] ?? 1;
                      total += (price * qty).toInt();
                    }
                    final totalStr = total.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
                    
                    return Card(
                      color: Color(0xFFD1E8F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Đơn ${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF01579B))),
                                Row(
                                  children: [
                                    Text(
                                      isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                                      style: TextStyle(
                                        color: isPaid ? Colors.green : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isPaid)
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                                        onPressed: () {
                                          setState(() {
                                            widget.orderHistory.removeAt(i);
                                          });
                                          widget.onUpdate();
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ...orderItems.map((item) => Row(
                                  children: [
                                    Expanded(child: Text('${item['restaurant']} x${item['quantity']}')),
                                    Text(item['total'] ?? '', style: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tổng cộng:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('$totalStr VNĐ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700])),
                              ],
                            ),
                            if (!isPaid) ...[
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.orderHistory[i].isPaid = true;
                                    });
                                    widget.onUpdate(); // This calls _saveOrdersToPrefs
                                  },
                                  child: Text('Xác nhận thanh toán'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF80DEEA),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
} 