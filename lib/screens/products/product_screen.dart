import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project/models/user.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Charger les produits depuis le serveur lors de l'initialisation
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://172.18.2.211:5005/product/products'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        setState(() {
          products = decodedData.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://172.18.2.211:5005/product/products/$productId'));

      if (response.statusCode == 200) {
        // Produit supprimé avec succès, mettre à jour l'état local
        setState(() {
          products.removeWhere((product) => product.id == productId);
        });
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<User?> fetchUserDetails(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://172.18.2.211:5005/user/users/$userId'));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        if (decodedData is Map<String, dynamic>) {
          return User.fromJson(decodedData);
        }
      }

      throw Exception('Failed to load user details');
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  List<String> getCategories() {
    Set<String> categories = {'All'};
    for (var product in products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = getCategories();

    return Column(
      children: [
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? value) {
            setState(() {
              selectedCategory = value!;
            });
          },
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              if (selectedCategory == 'All' ||
                  products[index].category == selectedCategory) {
                return FutureBuilder<User?>(
                  future: fetchUserDetails(products[index].restaurantId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Passer la liste de produits et de restaurants au widget de l'écran
                      return ProductCard(
                        product: products[index],
                        users: [
                          snapshot.data!
                        ], // Convertir l'utilisateur unique en une liste
                        onDelete: () => confirmDeleteProduct(products[index]),
                      );
                    }
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> confirmDeleteProduct(Product product) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this food offer?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await deleteProduct(product.id);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final List<User> users; // Liste des utilisateurs associés aux produits
  final VoidCallback onDelete; // Callback de suppression

  ProductCard({
    required this.product,
    required this.users,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Trouver l'utilisateur correspondant au produit
    User? matchingUser =
        users.firstWhereOrNull((user) => user.id == product.restaurantId);

    // Utiliser le nom d'utilisateur de l'utilisateur
    String userName = matchingUser?.username ?? 'Unknown User';

    return Card(
      elevation: 4.0,
      color: Color.fromARGB(255, 193, 255, 211),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              product.title,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.0),
            Text(
              '${product.price} TND',
              style: TextStyle(
                fontSize: 12.0,
                color: Color.fromARGB(255, 14, 13, 13),
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Catégorie: ${product.category}',
              style: TextStyle(
                fontSize: 12.0,
                color: Color.fromARGB(255, 238, 103, 36),
              ),
            ),
            SizedBox(height: 4.0),
            // Afficher le nom de l'utilisateur devant "Posted by"
            Text(
              'Posted by: $userName',
              style: TextStyle(
                fontSize: 12.0,
                color: Color.fromARGB(255, 84, 84, 84),
              ),
            ),
            SizedBox(height: 4.0),
            // Utilisation de la méthode
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
