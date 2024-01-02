import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project/models/product.dart';
import 'package:project/models/user.dart';

class TopRestaurantsStatsScreen extends StatelessWidget {
  final List<Product> products;
  final List<User> users; // Mise à jour du type pour utiliser le modèle User

  TopRestaurantsStatsScreen({required this.products, required this.users});

  List<Map<String, dynamic>> getTopUsers() {
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
    List<Map<String, dynamic>> topUsers = getTopUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Users Statistics'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'Top 3 Users with Most Products',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: topUsers.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> user = entry.value;

                  // Choisissez une couleur pour l'utilisateur en fonction du classement
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
                      color = Colors.grey; // Couleur par défaut
                  }

                  return PieChartSectionData(
                    color: color,
                    value: user['productCount'].toDouble(),
                    title: '${user['userName']}\n${user['productCount']} produits',
                    radius: 100.0,
                    titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList(),
                sectionsSpace: 0,  // Réglez cet espace selon vos préférences
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
