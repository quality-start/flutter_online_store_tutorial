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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        leading: Image.asset(
          'images/cyber.png',
          //todo:下記を指定しても画像の大きさは変わらなかったので後ほど調査
          //width: 100,
          //height: 100,
        ),
        leadingWidth: 150,
      ),
      endDrawer: Drawer(
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
            ListTile(
              leading: Icon(Icons.favorite),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart), // Icon aligned to the left
            ),
            ListTile(
              leading: Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
