import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/service_order_db_helper.dart';
import '../models/service_order.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Map<String, dynamic>> availableServices = [
    {
      'name': 'Đưa đón sân bay',
      'icon': 'airport_shuttle',
      'options': ['4 chỗ', '7 chỗ', '16 chỗ'],
      'unitLabel': 'chỗ',
    },
    {
      'name': 'Đồ bơi',
      'icon': 'pool',
      'options': ['S', 'M', 'L', 'XL'],
      'unitLabel': 'bộ',
    },
    {
      'name': 'Vật dụng chuyên dụng',
      'icon': 'construction',
      'options': ['Lều', 'Vợt cầu lông', 'Ghế xếp'],
      'unitLabel': 'món',
    },
    {
      'name': 'Xe lăn',
      'icon': 'accessible',
      'options': ['Có người đẩy', 'Tự điều khiển'],
      'unitLabel': 'xe',
    },
    {
      'name': 'Dụng cụ tập gym',
      'icon': 'fitness_center',
      'options': ['Tạ đơn', 'Dây kháng lực'],
      'unitLabel': 'món',
    },
    {
      'name': 'Thuyền kayak',
      'icon': 'sailing',
      'options': ['1 người', '2 người'],
      'unitLabel': 'thuyền',
    },
    {
      'name': 'Áo choàng tắm',
      'icon': 'checkroom',
      'options': ['S', 'M', 'L'],
      'unitLabel': 'áo',
    },
    {
      'name': 'Đèn pin ban đêm',
      'icon': 'flashlight_on',
      'options': ['Loại nhỏ', 'Loại lớn'],
      'unitLabel': 'cái',
    },
    {
      'name': 'Ô dù che nắng',
      'icon': 'umbrella',
      'options': ['Nhỏ', 'Trung bình', 'Lớn'],
      'unitLabel': 'cái',
    },
    {
      'name': 'Ván trượt nước',
      'icon': 'surfing',
      'options': ['Beginner', 'Pro'],
      'unitLabel': 'ván',
    },
  ];

  List<ServiceOrder> orderHistory = [];
  List<Map<String, dynamic>> currentOrder = [];

  @override
  void initState() {
    super.initState();
    _loadOrdersFromDb();
  }

  Future<void> _loadOrdersFromDb() async {
    final orders = await ServiceOrderDbHelper().getAllOrders();
    setState(() {
      orderHistory = orders;
    });
  }

  Future<void> _saveCurrentOrderToDb() async {
    if (currentOrder.isNotEmpty) {
      final order = ServiceOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List<Map<String, dynamic>>.from(currentOrder),
        date: DateTime.now().toIso8601String(),
      );
      await ServiceOrderDbHelper().insertOrder(order);
      currentOrder.clear();
      await _loadOrdersFromDb();
    }
  }

  void _selectService(
    Map<String, dynamic> service,
    int index, {
    Map<String, dynamic>? editingOrder,
  }) {
    String? selectedOption = editingOrder != null
        ? editingOrder['option']
        : service['options'][0];
    int quantity = editingOrder != null ? editingOrder['quantity'] : 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Chọn thông tin cho ${service['name']}',
          style: TextStyle(color: Color(0xFF01579B)),
        ),
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedOption,
                    isExpanded: true,
                    style: TextStyle(color: Color(0xFF01579B)),
                    dropdownColor: Color(0xFFD1E8F1),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedOption = value;
                      });
                    },
                    items: (service['options'] as List<String>)
                        .map<DropdownMenuItem<String>>(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: TextStyle(color: Color(0xFF01579B)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Số lượng:",
                        style: TextStyle(color: Color(0xFF01579B)),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Color(0xFF01579B)),
                            onPressed: quantity > 1
                                ? () => setStateDialog(() => quantity--)
                                : null,
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(color: Color(0xFF01579B)),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Color(0xFF01579B)),
                            onPressed: () => setStateDialog(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy", style: TextStyle(color: Color(0xFF01579B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF80DEEA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              setState(() {
                if (editingOrder != null) {
                  editingOrder['option'] = selectedOption;
                  editingOrder['quantity'] = quantity;
                } else {
                  currentOrder.add({
                    'serviceName': service['name'],
                    'icon': service['icon'],
                    'options': service['options'],
                    'unitLabel': service['unitLabel'],
                    'option': selectedOption,
                    'quantity': quantity,
                  });
                }
              });
              Navigator.pop(context);
            },
            child: Text("Xác nhận", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteCurrentOrderItem(Map<String, dynamic> order) {
    setState(() {
      currentOrder.remove(order);
    });
  }

  void _editCurrentOrderItem(Map<String, dynamic> order) {
    _selectService(
      {
        'name': order['serviceName'],
        'icon': order['icon'],
        'options': order['options'],
        'unitLabel': order['unitLabel'],
      },
      0,
      editingOrder: order,
    );
  }

  void _confirmCurrentOrder() async {
    await _saveCurrentOrderToDb();
    setState(() {
      currentOrder.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đơn hàng đã được xác nhận!')));
  }

  void _deleteHistoryOrder(String id) async {
    await ServiceOrderDbHelper().deleteOrder(id);
    await _loadOrdersFromDb();
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'airport_shuttle':
        return Icons.airport_shuttle;
      case 'pool':
        return Icons.pool;
      case 'construction':
        return Icons.construction;
      case 'accessible':
        return Icons.accessible;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'sailing':
        return Icons.sailing;
      case 'checkroom':
        return Icons.checkroom;
      case 'flashlight_on':
        return Icons.flashlight_on;
      case 'umbrella':
        return Icons.umbrella;
      case 'surfing':
        return Icons.surfing;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dịch vụ Resort',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0288D1), Color(0xFF00ACC1)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Các dịch vụ khả dụng:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01579B),
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(availableServices.length, (index) {
                var service = availableServices[index];
                return ElevatedButton.icon(
                  onPressed: () => _selectService(service, index),
                  icon: Icon(
                    _iconFromString(service['icon']),
                    color: Color(0xFF01579B),
                  ),
                  label: Text(
                    service['name'],
                    style: TextStyle(color: Color(0xFF01579B)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF80DEEA).withOpacity(0.1),
                    foregroundColor: Color(0xFF01579B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }),
            ),
            const Divider(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Tổng đơn hàng: ${orderHistory.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01579B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              return DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFE0F7FA),
                                          Color(0xFFB2EBF2),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(16.0),
                                        ),
                                        Expanded(
                                          child: orderHistory.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    'Chưa có lịch sử đơn nào.',
                                                    style: TextStyle(
                                                      color: Color(0xFF455A64),
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  controller: scrollController,
                                                  itemCount:
                                                      orderHistory.length,
                                                  itemBuilder: (context, index) {
                                                    final order =
                                                        orderHistory[index];
                                                    return Card(
                                                      color: const Color(
                                                        0xFFD1E8F1,
                                                      ),
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      child: ExpansionTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Đơn #${orderHistory.length - index} (${order.items.length} dịch vụ)',
                                                              style:
                                                                  const TextStyle(
                                                                    color: Color(
                                                                      0xFF01579B,
                                                                    ),
                                                                  ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Color(
                                                                  0xFFFF5722,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                _deleteHistoryOrder(
                                                                  order.id,
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        children: order.items.map((
                                                          item,
                                                        ) {
                                                          return ListTile(
                                                            leading: Icon(
                                                              _iconFromString(
                                                                item['icon'] ??
                                                                    '',
                                                              ),
                                                              color:
                                                                  const Color(
                                                                    0xFF01579B,
                                                                  ),
                                                            ),
                                                            title: Text(
                                                              item['serviceName'] ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                    color: Color(
                                                                      0xFF01579B,
                                                                    ),
                                                                  ),
                                                            ),
                                                            subtitle: Text(
                                                              '${item['option'] ?? ''} - ${item['unitLabel'] ?? ''}: ${item['quantity'] ?? ''}',
                                                              style:
                                                                  const TextStyle(
                                                                    color: Color(
                                                                      0xFF455A64,
                                                                    ),
                                                                  ),
                                                            ),
                                                            trailing: IconButton(
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color: Color(
                                                                  0xFF80DEEA,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                String?
                                                                selectedOption =
                                                                    item['option'] ??
                                                                    (item['options'] !=
                                                                                null &&
                                                                            (item['options']
                                                                                    as List)
                                                                                .isNotEmpty
                                                                        ? item['options'][0]
                                                                        : null);
                                                                int quantity =
                                                                    item['quantity'] ??
                                                                    1;
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (context) => AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            24,
                                                                          ),
                                                                    ),
                                                                    title: Text(
                                                                      'Chỉnh sửa ${item['serviceName'] ?? ''}',
                                                                      style: const TextStyle(
                                                                        color: Color(
                                                                          0xFF01579B,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    content: Container(
                                                                      decoration: const BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                          colors: [
                                                                            Color(
                                                                              0xFFE0F7FA,
                                                                            ),
                                                                            Color(
                                                                              0xFFB2EBF2,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      child: StatefulBuilder(
                                                                        builder:
                                                                            (
                                                                              context,
                                                                              setStateDialog,
                                                                            ) {
                                                                              return Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  DropdownButton<
                                                                                    String
                                                                                  >(
                                                                                    value: selectedOption,
                                                                                    isExpanded: true,
                                                                                    style: const TextStyle(
                                                                                      color: Color(
                                                                                        0xFF01579B,
                                                                                      ),
                                                                                    ),
                                                                                    dropdownColor: const Color(
                                                                                      0xFFD1E8F1,
                                                                                    ),
                                                                                    onChanged:
                                                                                        (
                                                                                          value,
                                                                                        ) {
                                                                                          setStateDialog(
                                                                                            () {
                                                                                              selectedOption = value;
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                    items:
                                                                                        (item['options']
                                                                                                    as List<
                                                                                                      dynamic
                                                                                                    >? ??
                                                                                                [])
                                                                                            .map<
                                                                                              DropdownMenuItem<
                                                                                                String
                                                                                              >
                                                                                            >(
                                                                                              (
                                                                                                option,
                                                                                              ) =>
                                                                                                  DropdownMenuItem<
                                                                                                    String
                                                                                                  >(
                                                                                                    value: option.toString(),
                                                                                                    child: Text(
                                                                                                      option.toString(),
                                                                                                      style: const TextStyle(
                                                                                                        color: Color(
                                                                                                          0xFF01579B,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                            )
                                                                                            .toList(),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 12,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "Số lượng:",
                                                                                        style: TextStyle(
                                                                                          color: Color(
                                                                                            0xFF01579B,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.remove,
                                                                                              color: Color(
                                                                                                0xFF01579B,
                                                                                              ),
                                                                                            ),
                                                                                            onPressed:
                                                                                                quantity >
                                                                                                    1
                                                                                                ? () => setStateDialog(
                                                                                                    () => quantity--,
                                                                                                  )
                                                                                                : null,
                                                                                          ),
                                                                                          Text(
                                                                                            quantity.toString(),
                                                                                            style: const TextStyle(
                                                                                              color: Color(
                                                                                                0xFF01579B,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          IconButton(
                                                                                            icon: const Icon(
                                                                                              Icons.add,
                                                                                              color: Color(
                                                                                                0xFF01579B,
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () => setStateDialog(
                                                                                              () => quantity++,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 16,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      TextButton(
                                                                                        onPressed: () => Navigator.pop(
                                                                                          context,
                                                                                        ),
                                                                                        child: const Text(
                                                                                          "Hủy",
                                                                                          style: TextStyle(
                                                                                            color: Color(
                                                                                              0xFF01579B,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: const Color(
                                                                                            0xFF80DEEA,
                                                                                          ),
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              16,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          item['option'] = selectedOption;
                                                                                          item['quantity'] = quantity;
                                                                                          Navigator.pop(
                                                                                            context,
                                                                                          );
                                                                                          setState(
                                                                                            () {},
                                                                                          );
                                                                                        },
                                                                                        child: const Text(
                                                                                          "Xác nhận",
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF80DEEA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Lịch sử đơn',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (currentOrder.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Đơn hàng hiện tại:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...currentOrder.map((order) {
                      if (order == null) return const SizedBox.shrink();
                      return Card(
                        color: const Color(0xFFD1E8F1),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            _iconFromString(order['icon'] ?? ''),
                            color: const Color(0xFF01579B),
                          ),
                          title: Text(
                            order['serviceName'] ?? '',
                            style: const TextStyle(color: Color(0xFF01579B)),
                          ),
                          subtitle: Text(
                            '${order['option'] ?? ''} - ${order['unitLabel'] ?? ''}: ${order['quantity'] ?? ''}',
                            style: const TextStyle(color: Color(0xFF455A64)),
                          ),
                          trailing: Wrap(
                            spacing: 10,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF80DEEA),
                                ),
                                onPressed: () => _editCurrentOrderItem(order),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFFF5722),
                                ),
                                onPressed: () => _deleteCurrentOrderItem(order),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        onPressed: _confirmCurrentOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF80DEEA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Xác nhận đơn',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
              Expanded(
                child: orderHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có lịch sử đơn nào.',
                          style: TextStyle(color: Color(0xFF455A64)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: orderHistory.length < 3
                            ? orderHistory.length
                            : 3,
                        itemBuilder: (context, i) {
                          final index = i;
                          final order = orderHistory[index];
                          return Card(
                            color: const Color(0xFFD1E8F1),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ExpansionTile(
                              title: Text(
                                'Đơn #${orderHistory.length - index} (${order.items.length} dịch vụ)',
                                style: const TextStyle(
                                  color: Color(0xFF01579B),
                                ),
                              ),
                              children: order.items.map((item) {
                                return ListTile(
                                  leading: Icon(
                                    _iconFromString(item['icon']),
                                    color: const Color(0xFF01579B),
                                  ),
                                  title: Text(
                                    item['serviceName'],
                                    style: const TextStyle(
                                      color: Color(0xFF01579B),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${item['option']} - ${item['unitLabel']}: ${item['quantity']}',
                                    style: const TextStyle(
                                      color: Color(0xFF455A64),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF80DEEA),
                                    ),
                                    onPressed: () {
                                      String? selectedOption =
                                          item['option'] ??
                                          (item['options'] != null &&
                                                  (item['options'] as List)
                                                      .isNotEmpty
                                              ? item['options'][0]
                                              : null);
                                      int quantity = item['quantity'] ?? 1;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          title: Text(
                                            'Chỉnh sửa ${item['serviceName'] ?? ''}',
                                            style: const TextStyle(
                                              color: Color(0xFF01579B),
                                            ),
                                          ),
                                          content: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFFE0F7FA),
                                                  Color(0xFFB2EBF2),
                                                ],
                                              ),
                                            ),
                                            child: StatefulBuilder(
                                              builder: (context, setStateDialog) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    DropdownButton<String>(
                                                      value: selectedOption,
                                                      isExpanded: true,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF01579B,
                                                        ),
                                                      ),
                                                      dropdownColor:
                                                          const Color(
                                                            0xFFD1E8F1,
                                                          ),
                                                      onChanged: (value) {
                                                        setStateDialog(() {
                                                          selectedOption =
                                                              value;
                                                        });
                                                      },
                                                      items:
                                                          (item['options']
                                                                      as List<
                                                                        dynamic
                                                                      >? ??
                                                                  [])
                                                              .map<
                                                                DropdownMenuItem<
                                                                  String
                                                                >
                                                              >(
                                                                (
                                                                  option,
                                                                ) => DropdownMenuItem<String>(
                                                                  value: option
                                                                      .toString(),
                                                                  child: Text(
                                                                    option
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                      color: Color(
                                                                        0xFF01579B,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Số lượng:",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF01579B,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.remove,
                                                                color: Color(
                                                                  0xFF01579B,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  quantity > 1
                                                                  ? () => setStateDialog(
                                                                      () =>
                                                                          quantity--,
                                                                    )
                                                                  : null,
                                                            ),
                                                            Text(
                                                              quantity
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                    color: Color(
                                                                      0xFF01579B,
                                                                    ),
                                                                  ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.add,
                                                                color: Color(
                                                                  0xFF01579B,
                                                                ),
                                                              ),
                                                              onPressed: () =>
                                                                  setStateDialog(
                                                                    () =>
                                                                        quantity++,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child: const Text(
                                                            "Hủy",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF01579B,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                  0xFF80DEEA,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            item['option'] =
                                                                selectedOption;
                                                            item['quantity'] =
                                                                quantity;
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            setState(() {});
                                                          },
                                                          child: const Text(
                                                            "Xác nhận",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
