import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ProductsModel {
  ProductsModel({
    required this.title,
    required this.memory,
    required this.price,
    required this.image,
  });
  final String title;
  final String memory;
  final double price;
  final String image;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(90, (index) => '${index + 1}');
    return Scaffold(
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
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 9 / 16,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Center(child: Text('${index + 1}')),
            );
          },
        ),
      ),
    );
  }
}
