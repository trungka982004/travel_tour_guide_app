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
      'icon': Icons.airport_shuttle,
      'options': ['4 chỗ', '7 chỗ', '16 chỗ'],
      'unitLabel': 'chỗ'
    },
    {
      'name': 'Đồ bơi',
      'icon': Icons.pool,
      'options': ['S', 'M', 'L', 'XL'],
      'unitLabel': 'bộ'
    },
    {
      'name': 'Vật dụng chuyên dụng',
      'icon': Icons.construction,
      'options': ['Lều', 'Vợt cầu lông', 'Ghế xếp'],
      'unitLabel': 'món'
    },
    {
      'name': 'Xe lăn',
      'icon': Icons.accessible,
      'options': ['Có người đẩy', 'Tự điều khiển'],
      'unitLabel': 'xe'
    },
    {
      'name': 'Dụng cụ tập gym',
      'icon': Icons.fitness_center,
      'options': ['Tạ đơn', 'Dây kháng lực'],
      'unitLabel': 'món'
    },
    {
      'name': 'Thuyền kayak',
      'icon': Icons.sailing,
      'options': ['1 người', '2 người'],
      'unitLabel': 'thuyền'
    },
    {
      'name': 'Áo choàng tắm',
      'icon': Icons.checkroom,
      'options': ['S', 'M', 'L'],
      'unitLabel': 'áo'
    },
    {
      'name': 'Đèn pin ban đêm',
      'icon': Icons.flashlight_on,
      'options': ['Loại nhỏ', 'Loại lớn'],
      'unitLabel': 'cái'
    },
    {
      'name': 'Ô dù che nắng',
      'icon': Icons.umbrella,
      'options': ['Nhỏ', 'Trung bình', 'Lớn'],
      'unitLabel': 'cái'
    },
    {
      'name': 'Ván trượt nước',
      'icon': Icons.surfing,
      'options': ['Beginner', 'Pro'],
      'unitLabel': 'ván'
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

  Future<void> _deleteOrder(String id) async {
    await ServiceOrderDbHelper().deleteOrder(id);
    await _loadOrdersFromDb();
  }

  void _selectService(Map<String, dynamic> service, int index, {Map<String, dynamic>? editingOrder}) {
    String? selectedOption = editingOrder != null ? editingOrder['option'] : service['options'][0];
    int quantity = editingOrder != null ? editingOrder['quantity'] : 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn thông tin cho ${service['name']}'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedOption,
                  isExpanded: true,
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedOption = value;
                    });
                  },
                  items: (service['options'] as List<String>)
                      .map<DropdownMenuItem<String>>(
                        (option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Số lượng:"),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              setStateDialog(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setStateDialog(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (editingOrder != null) {
                  editingOrder['option'] = selectedOption;
                  editingOrder['quantity'] = quantity;
                } else {
                  currentOrder.add({
                    'service': service,
                    'option': selectedOption,
                    'quantity': quantity,
                  });
                }
              });
              _saveCurrentOrderToDb();
              Navigator.pop(context);
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  void _deleteCurrentOrderItem(Map<String, dynamic> order) {
    setState(() {
      currentOrder.remove(order);
    });
    _saveCurrentOrderToDb();
  }

  void _editCurrentOrderItem(Map<String, dynamic> order) {
    _selectService(order['service'], 0, editingOrder: order);
  }

  void _confirmCurrentOrder() {
    if (currentOrder.isEmpty) return;
    _saveCurrentOrderToDb();
  }

  void _deleteHistoryOrder(String id) {
    _deleteOrder(id);
  }

  void _editOrderDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa đơn #$id'),
          content: SizedBox(
            width: 350,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderHistory.length,
              itemBuilder: (context, idx) {
                final order = orderHistory[idx];
                final service = order.items.firstWhere(
                  (item) => item['service']['name'] == order.items[idx]['service']['name'],
                  orElse: () => {},
                )['service'];
                return ListTile(
                  leading: Icon(service['icon'], color: Colors.deepOrange),
                  title: Text(service['name']),
                  subtitle: Text('${order.items[idx]['option']} - ${service['unitLabel']}: ${order.items[idx]['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          // Edit this service in the order
                          String? selectedOption = order.items[idx]['option'];
                          int quantity = order.items[idx]['quantity'];
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Chỉnh sửa ${service['name']}'),
                              content: StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButton<String>(
                                        value: selectedOption,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setStateDialog(() {
                                            selectedOption = value;
                                          });
                                        },
                                        items: (service['options'] as List<String>)
                                            .map<DropdownMenuItem<String>>(
                                              (option) => DropdownMenuItem<String>(
                                                value: option,
                                                child: Text(option),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Số lượng:"),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  if (quantity > 1) {
                                                    setStateDialog(() {
                                                      quantity--;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(quantity.toString()),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    quantity++;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hủy"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    order.items[idx]['option'] = selectedOption;
                                    order.items[idx]['quantity'] = quantity;
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Xác nhận"),
                                ),
                              ],
                            ),
                          );
                          setState(() {
                            orderHistory[idx] = order;
                          });
                          _saveCurrentOrderToDb();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ Resort'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Các dịch vụ khả dụng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(availableServices.length, (index) {
              var service = availableServices[index];
              return ElevatedButton.icon(
                onPressed: () => _selectService(service, index),
                icon: Icon(service['icon']),
                label: Text(service['name']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.black,
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              builder: (context, scrollController) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                    ),
                                    Expanded(
                                      child: orderHistory.isEmpty
                                          ? const Center(child: Text('Chưa có lịch sử đơn nào.'))
                                          : ListView.builder(
                                              controller: scrollController,
                                              itemCount: orderHistory.length,
                                              itemBuilder: (context, index) {
                                                final order = orderHistory[index];
                                                return Card(
                                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: ExpansionTile(
                                                    title: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('Đơn #${orderHistory.length - index} (${order.items.length} dịch vụ)'),
                                                        IconButton(
                                                          icon: const Icon(Icons.delete, color: Colors.red),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            _deleteHistoryOrder(order.id);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    children: order.items.map((item) {
                                                      final service = item['service'];
                                                      return ListTile(
                                                        leading: Icon(service['icon'], color: Colors.green),
                                                        title: Text(service['name']),
                                                        subtitle: Text('${item['option']} - ${service['unitLabel']}: ${item['quantity']}'),
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Text('Lịch sử đơn'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (currentOrder.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Đơn hàng hiện tại:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...currentOrder.map((order) {
                    final service = order['service'];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(service['icon'], color: Colors.deepOrange),
                        title: Text(service['name']),
                        subtitle: Text('${order['option']} - ${service['unitLabel']}: ${order['quantity']}'),
                        trailing: Wrap(
                          spacing: 10,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editCurrentOrderItem(order),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCurrentOrderItem(order),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ElevatedButton(
                      onPressed: _confirmCurrentOrder,
                      child: const Text('Xác nhận đơn'),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: orderHistory.isEmpty
                  ? const Center(child: Text('Chưa có lịch sử đơn nào.'))
                  : ListView.builder(
                      itemCount: orderHistory.length < 3 ? orderHistory.length : 3,
                      itemBuilder: (context, i) {
                        final index = i;
                        final order = orderHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ExpansionTile(
                            title: Text('Đơn #${orderHistory.length - index} (${order.items.length} dịch vụ)'),
                            children: order.items.map((item) {
                              final service = item['service'];
                              return ListTile(
                                leading: Icon(service['icon'], color: Colors.green),
                                title: Text(service['name']),
                                subtitle: Text('${item['option']} - ${service['unitLabel']}: ${item['quantity']}'),
                              );
                            }).toList(),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editOrderDialog(order.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
