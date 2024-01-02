import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project/dashboard/toprestaurant_screen.dart';
import 'package:project/models/product.dart';
import 'package:project/models/user.dart';
import 'package:project/screens/products/product_screen.dart';
import 'package:project/screens/orders/order_screen.dart';
import 'package:project/models/menu_item.dart';
import 'package:project/screens/users/user_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;

  List<MenuItem> menuItems = [
    MenuItem(title: 'Dashboard', icon: Icons.dashboard),
    MenuItem(title: 'Users', icon: Icons.person),
    MenuItem(title: 'Orders', icon: Icons.shopping_cart),
    MenuItem(title: 'Food Offers', icon: Icons.category),
    MenuItem(title: 'Log Out', icon: Icons.logout),
  ];

  int selectedIndex = 0;

  // Liste des écrans disponibles
  List<Widget> screens = [];

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
    final response = await http.get(Uri.parse('http://172.18.2.211:5005/product/products'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      List<Product> products = decodedData.map((data) => Product.fromJson(data)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://172.18.2.211:5005/user/users'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        users = decodedData.map((data) => User.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

List<Map<String, dynamic>> getTopRestaurants(List<Product> products, List<User> users) {
  Map<String, int> userCount = {};

  for (Product product in products) {
    // Trouver l'utilisateur correspondant au produit
    User? matchingUser = users.firstWhereOrNull((user) => user.id == product.restaurantId);

    // Utiliser le nom d'utilisateur de l'utilisateur
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
      body: Row(
        children: [
          NavigationRail(
            extended: isExpanded,
            backgroundColor: Color.fromARGB(255, 0, 101, 61),
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.white,
            ),
            selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 53, 91, 60)),
            destinations: menuItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.title),
                    ))
                .toList(),
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            icon: Icon(Icons.menu),
                          ),
                          SizedBox(width: 10.0),
                          Image.asset(
                            'images/logoflutter.png',
                            height: 120,
                            width: 120,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  // Affichage de l'écran actif
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: [
                        FutureBuilder<List<Product>>(
                          future: productsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Passer la liste de produits et de restaurants au widget de l'écran
                              return TopRestaurantsStatsScreen(
                                products: snapshot.data!,
                               users: users,
                              );
                            }
                          },
                        ),
                        // Écran des utilisateurs
                        UserAndRestaurantScreen(),
                        // Écran des commandes
                        OrderScreen(),
                        // Écran des produits
                        ProductScreen(),
                        // Écran de déconnexion
                        Placeholder(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
