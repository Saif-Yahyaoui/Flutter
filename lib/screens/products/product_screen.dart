import 'package:admin/models/User.dart';
import 'package:admin/models/product.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/products/stat_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
              );
            },
          ),
        ],
      ),
      body: Responsive(
        mobile: ProductList(),
        tablet: ProductList(),
        desktop: ProductList(),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  List<User> users = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Charger les produits et les utilisateurs depuis le serveur lors de l'initialisation
    fetchProducts();
    fetchUsers();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:7020/product/products'));

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

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:7020/user/users'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        setState(() {
          users = decodedData.map((data) => User.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
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
        SizedBox(height: 16.0),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isDesktop(context) ? 3 : 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              if (selectedCategory == 'All' || products[index].category == selectedCategory) {
                // Trouver l'utilisateur correspondant au produit
                User? matchingUser = users.firstWhereOrNull((user) => user.id == products[index].restaurantId);

                // Utiliser le nom d'utilisateur de l'utilisateur
                String userName = matchingUser?.username ?? 'Unknown User';

                return ProductCard(
                  product: products[index],
                  userName: userName,
                  onDelete: () => confirmDeleteProduct(products[index]),
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

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:7020/product/products/$productId'));

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
}

class ProductCard extends StatelessWidget {
  final Product product;
  final String userName;
  final VoidCallback onDelete;

  ProductCard({
    required this.product,
    required this.userName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Color.fromARGB(255, 51, 60, 114),
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
              style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 238, 103, 36)),
            ),
            SizedBox(height: 4.0),
            Text(
              'Catégorie: ${product.category}',
              style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 238, 103, 36)),
            ),
            SizedBox(height: 4.0),
            // Afficher le nom de l'utilisateur devant "Posted by"
            Text(
              'Posted by: $userName',
              style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            SizedBox(height: 8.0),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
