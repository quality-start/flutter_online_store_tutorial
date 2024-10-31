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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white54,
              title: Image.asset('images/cyber.png'),
              centerTitle: true,
              pinned: true,
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // フィルターボタンのアクション
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                    DropdownButton<String>(
                      onChanged: (value) {
                        // ドロップダウンのアクション
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: const Text('By rating'),
                      items: <String>['High to Low', 'Low to High']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Products Result : ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '85',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(product: products[index]);
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
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
      ),
    );
  }
}
