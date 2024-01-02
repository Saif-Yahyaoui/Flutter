import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/user.dart';
import 'package:project/models/restaurant.dart';

class UserAndRestaurantScreen extends StatefulWidget {
  @override
  _UserAndRestaurantScreenState createState() => _UserAndRestaurantScreenState();
}

class _UserAndRestaurantScreenState extends State<UserAndRestaurantScreen> {
  List<User> users = [];
  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchRestaurants();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http:/192.168.100.117:5005/user/users'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        users = decodedData.map((data) => User.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> fetchRestaurants() async {
    final response = await http.get(Uri.parse('http://192.168.100.117:5005/restaurant/restaurants'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        restaurants = decodedData.map((data) => Restaurant.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Section pour les utilisateurs
          ListTile(
            title: Text('All Users'),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Phone Number')),
              DataColumn(label: Text('Role')),
            ],
            rows: users.map((user) => DataRow(
              cells: [
                DataCell(Text(user.id)),
                DataCell(Text(user.username)),
                DataCell(Text(user.email)),
                DataCell(Text(user.phoneNumber)),
                DataCell(Text(user.role)),
              ],
            )).toList(),
          ),

          // Section pour les restaurants
          ListTile(
            title: Text('Restaurants'),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Description')),
            ],
            rows: restaurants.map((restaurant) => DataRow(
              cells: [
                DataCell(Text(restaurant.id)),
                DataCell(
                  Image.network(
                    restaurant.image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                DataCell(Text(restaurant.category)),
                DataCell(Text(restaurant.description)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
