import 'package:flutter/material.dart';
import 'package:project/screens/products/product_screen.dart';
import 'package:project/models/menu_item.dart';

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
    MenuItem(title: 'Products', icon: Icons.category),
    MenuItem(title: 'Log Out', icon: Icons.logout),
  ];

  int selectedIndex = 0;

  // Liste des écrans disponibles
  List<Widget> screens = [
    // Écran du tableau de bord (écran par défaut)
    Placeholder(),  // Remplacez Placeholder par votre écran de tableau de bord

    // Écran des utilisateurs
    Placeholder(),  // Remplacez Placeholder par votre écran d'utilisateurs

    // Écran des commandes
    Placeholder(),  // Remplacez Placeholder par votre écran de commandes

    // Écran des produits
    ProductScreen(),

    // Écran de déconnexion
    Placeholder(),  // Remplacez Placeholder par votre écran de déconnexion
  ];

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
            selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 4, 36, 10)),
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
                  Image.asset(
                    'images/logoflutter.png',
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        icon: Icon(Icons.menu),
                      ),
                      // Ajouter d'autres éléments ici si nécessaire
                    ],
                  ),
                  // Affichage de l'écran actif
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: screens,
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
