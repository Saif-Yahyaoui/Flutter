import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Responsive(
        mobile: OrderList(),
        tablet: OrderList(),
        desktop: OrderList(),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<dynamic> orders = [];
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    // Load orders from the server on initialization
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response =
        await http.get(Uri.parse('http://localhost:7020/order/orders'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        orders = decodedData;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  List<Map<String, String>> getStatusFilters() {
    return [
      {'label': 'All', 'value': 'All'},
      {'label': 'Pending', 'value': 'Pending'},
      {'label': 'Accepted', 'value': 'Accepted'},
      {'label': 'Declined', 'value': 'Declined'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton<String>(
                value: selectedStatus,
                items: getStatusFilters()
                    .map((filter) => DropdownMenuItem<String>(
                          value: filter['value'],
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              filter['label']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Order ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Order Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: orders
                .where((order) =>
                    selectedStatus.toLowerCase() == 'all' ||
                    order['status'].toLowerCase() ==
                        selectedStatus.toLowerCase())
                .map((order) => DataRow(
                      cells: [
                        DataCell(Text(order['_id'])),
                        DataCell(Text(order['createdAt']
                            .toString()
                            .split('.')
                            .first)),
                        DataCell(
                          Text(
                            order['status'],
                            style: TextStyle(
                              color: order['status'].toLowerCase() ==
                                      'accepted'
                                  ? Colors.green.shade400
                                  : Color.fromARGB(255, 86, 188, 113),
                            ),
                          ),
                        ),
                        DataCell(Text('${order['totalAmount']} \TND')),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
