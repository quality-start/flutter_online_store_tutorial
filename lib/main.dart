import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white54,
          title: Image.asset('images/cyber.png'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: const <Widget>[
              ListTile(
                title: Text('Home'),
              ),
              ListTile(
                title: Text('About'),
              ),
              ListTile(
                title: Text('Contact Us'),
              ),
              ListTile(
                title: Text('Blog'),
              ),
            ],
          ),
        ),
        body: ProductGrid(),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  ProductGrid({super.key});

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Apple iPhone 14 Pro',
      'storage': '512GB',
      'color': 'Gold',
      'model': 'MQ2...',
      'price': 1437,
      'image': 'images/iphone14pro_gold.png',
    },
    {
      'name': 'Apple iPhone 11',
      'storage': '128GB',
      'color': 'White',
      'model': 'MQ...',
      'price': 510,
      'image': 'images/iphone11.png',
    },
    {
      'name': 'Apple iPhone 11_white',
      'storage': '128GB',
      'color': 'White',
      'model': '...',
      'price': 550,
      'image': 'images/iphone11_white.png',
    },
    {
      'name': 'Apple iPhone 14 Pro',
      'storage': '1TB',
      'color': 'Gold',
      'model': 'MQ2V3',
      'price': 1499,
      'image': 'images/iphone14pro.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.45,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset(
                product['image'] as String,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.favorite_border, color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product['name']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product['storage']} ${product['color']} (${product['model']})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product['price']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
