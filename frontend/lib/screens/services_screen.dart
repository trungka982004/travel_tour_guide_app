import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  List<Map<String, dynamic>> currentOrder = [];
  List<List<Map<String, dynamic>>> orderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getString('currentOrder');
    final history = prefs.getString('orderHistory');
    setState(() {
      currentOrder = current != null
          ? List<Map<String, dynamic>>.from(json.decode(current)).map((order) {
              final service = availableServices.firstWhere(
                (s) => s['name'] == order['serviceName'],
                orElse: () => {},
              );
              if (service.isEmpty) return null;
              return {
                'service': service,
                'option': order['option'],
                'quantity': order['quantity'],
              };
            }).where((order) => order != null).cast<Map<String, dynamic>>().toList()
          : [];
      orderHistory = history != null
          ? List<List<Map<String, dynamic>>>.from(
              (json.decode(history) as List).map((orderList) {
                return List<Map<String, dynamic>>.from(orderList).map((order) {
                  final service = availableServices.firstWhere(
                    (s) => s['name'] == order['serviceName'],
                    orElse: () => {},
                  );
                  if (service.isEmpty) return null;
                  return {
                    'service': service,
                    'option': order['option'],
                    'quantity': order['quantity'],
                  };
                }).where((order) => order != null).cast<Map<String, dynamic>>().toList();
              }),
            )
          : [];
    });
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final currentToSave = currentOrder
        .map((order) => {
              'serviceName': order['service']['name'],
              'option': order['option'],
              'quantity': order['quantity'],
            })
        .toList();
    final historyToSave = orderHistory
        .map((orderList) =>
            orderList.map((order) => {
                  'serviceName': order['service']['name'],
                  'option': order['option'],
                  'quantity': order['quantity'],
                }).toList())
        .toList();
    await prefs.setString('currentOrder', json.encode(currentToSave));
    await prefs.setString('orderHistory', json.encode(historyToSave));
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
              _saveOrders();
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
    _saveOrders();
  }

  void _editCurrentOrderItem(Map<String, dynamic> order) {
    _selectService(order['service'], 0, editingOrder: order);
  }

  void _confirmCurrentOrder() {
    if (currentOrder.isEmpty) return;
    setState(() {
      orderHistory.insert(0, List<Map<String, dynamic>>.from(currentOrder));
      currentOrder.clear();
    });
    _saveOrders();
  }

  void _deleteHistoryOrder(int index) {
    setState(() {
      orderHistory.removeAt(index);
    });
    _saveOrders();
  }

  void _editOrderDialog(int orderIndex) {
    final List<Map<String, dynamic>> orderList = List<Map<String, dynamic>>.from(orderHistory[orderIndex].map((e) => Map<String, dynamic>.from(e)));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa đơn #${orderHistory.length - orderIndex}'),
          content: SizedBox(
            width: 350,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, idx) {
                final order = orderList[idx];
                final service = order['service'];
                return ListTile(
                  leading: Icon(service['icon'], color: Colors.deepOrange),
                  title: Text(service['name']),
                  subtitle: Text('${order['option']} - ${service['unitLabel']}: ${order['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          // Edit this service in the order
                          String? selectedOption = order['option'];
                          int quantity = order['quantity'];
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
                                    order['option'] = selectedOption;
                                    order['quantity'] = quantity;
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Xác nhận"),
                                ),
                              ],
                            ),
                          );
                          setState(() {
                            orderHistory[orderIndex][idx] = order;
                          });
                          _saveOrders();
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
                                                final orderList = orderHistory[index];
                                                return Card(
                                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: ExpansionTile(
                                                    title: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text('Đơn #${orderHistory.length - index} (${orderList.length} dịch vụ)'),
                                                        IconButton(
                                                          icon: const Icon(Icons.delete, color: Colors.red),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            _deleteHistoryOrder(index);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    children: orderList.map((order) {
                                                      final service = order['service'];
                                                      return ListTile(
                                                        leading: Icon(service['icon'], color: Colors.green),
                                                        title: Text(service['name']),
                                                        subtitle: Text('${order['option']} - ${service['unitLabel']}: ${order['quantity']}'),
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
                        final orderList = orderHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ExpansionTile(
                            title: Text('Đơn #${orderHistory.length - index} (${orderList.length} dịch vụ)'),
                            children: orderList.map((order) {
                              final service = order['service'];
                              return ListTile(
                                leading: Icon(service['icon'], color: Colors.green),
                                title: Text(service['name']),
                                subtitle: Text('${order['option']} - ${service['unitLabel']}: ${order['quantity']}'),
                              );
                            }).toList(),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editOrderDialog(index),
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
