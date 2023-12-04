import 'package:flutter/material.dart';
import 'package:project/models/product.dart';

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
  List<Product> products = [
    Product(
      title: 'Korean BBQ Burger',
      price: 8,
      imageUrl: 'images/koreanburger.jpg',
      category: 'Fast Food',
    ),
    Product(
      title: 'Cheese Burger',
      price: 6,
      imageUrl: 'images/burger.jpg',
      category: 'Fast Food',
    ),
    Product(
      title: 'Cheesecake',
      price: 9,
      imageUrl: 'https://beyondfrosting.com/wp-content/uploads/2023/09/Easy-No-Bake-Chocolate-Cheesecake-009-2.jpg',
      category: 'Dessert',
    ),
    Product(
      title: 'Pasta',
      price: 10,
      imageUrl: 'https://assets.afcdn.com/recipe/20180326/78158_w1024h576c1cx2736cy1824cxt0cyt0cxb5472cyb3648.webp',
      category: 'Main Meal',
    ),
    Product(
      title: 'Salad',
      price: 4,
      imageUrl: 'images/salad.jpg',
      category: 'Healthy',
    ),
  ];

  String selectedCategory = 'All';

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
              onPressed: () {
                deleteProduct(product);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(Product product) {
    setState(() {
      products.remove(product);
    });
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
              if (selectedCategory == 'All' || products[index].category == selectedCategory) {
                return ProductCard(
                  product: products[index],
                  onDelete: () => confirmDeleteProduct(products[index]),
                );
              } else {
                return SizedBox.shrink(); // Retourne un widget vide pour les produits qui ne correspondent pas à la catégorie sélectionnée
              }
            },
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  ProductCard({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
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
              style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 14, 13, 13)),
            ),
            SizedBox(height: 4.0),
            Text(
              'Catégorie: ${product.category}',
              style: TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 238, 103, 36)),
            ),
            SizedBox(height: 8.0),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
