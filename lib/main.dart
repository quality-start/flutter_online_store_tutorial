import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(90, (index) => '${index + 1}');
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
      ),
    );
  }
}
