import 'package:flutter/material.dart';

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

  List<Map<String, dynamic>> currentOrders = [];

  void _selectService(Map<String, dynamic> service, int index) {
    String? selectedOption = service['options'][0];
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn thông tin cho ${service['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedOption,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
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
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentOrders.add({
                  'service': service,
                  'option': selectedOption,
                  'quantity': quantity,
                  'confirmed': false
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dịch vụ Resort')), 
      body: SingleChildScrollView(
        child: Column(
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Đơn hàng hiện tại:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...currentOrders.map((order) {
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
                        onPressed: () => _selectService(service, 0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            currentOrders.remove(order);
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            order['confirmed'] = true;
                          });
                        },
                        child: const Text("Xác nhận"),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
