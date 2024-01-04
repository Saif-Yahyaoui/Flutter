import 'package:admin/models/User.dart';
import 'package:admin/models/product.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Product>> productsFuture;
  late List<User> users;

  @override
  void initState() {
    super.initState();
    // Initialiser le futur des produits lors de l'initialisation de l'écran
    productsFuture = fetchProducts();
    fetchUsers();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:7020/product/products'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      List<Product> products =
          decodedData.map((data) => Product.fromJson(data)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:7020/user/users'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        users = decodedData.map((data) => User.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  List<Map<String, dynamic>> getTopUsers(List<Product> products, List<User> users) {
    Map<String, int> userCount = {};

    for (Product product in products) {
      User? matchingUser =
          users.firstWhereOrNull((user) => user.id == product.restaurantId);

      String userName = matchingUser?.username ?? 'Unknown User';

      userCount[userName] = (userCount[userName] ?? 0) + 1;
    }

    List<MapEntry<String, int>> sortedUsers = userCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedUsers.take(3).map((entry) {
      return {
        'userName': entry.key,
        'productCount': entry.value,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics Screen'),
      ),
      body: FutureBuilder(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product> products = snapshot.data as List<Product>;
            List<Map<String, dynamic>> topUsers = getTopUsers(products, users);

            return Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Top 3 Users with Most Products',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: buildPieChart(topUsers),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildPieChart(List<Map<String, dynamic>> topUsers) {
    return PieChart(
      PieChartData(
        sections: topUsers.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> user = entry.value;

          Color color;
          switch (index) {
            case 0:
              color = Color.fromARGB(255, 2, 85, 42)!;
              break;
            case 1:
              color = Color.fromARGB(255, 30, 161, 65)!;
              break;
            case 2:
              color = Color.fromARGB(255, 96, 204, 108)!;
              break;
            default:
              color = Colors.grey;
          }

          return PieChartSectionData(
            color: color,
            value: user['productCount'].toDouble(),
            title: '${user['userName']}\n${user['productCount']} produits',
            radius: 100.0,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }
}
