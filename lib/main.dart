import 'package:flutter/material.dart';
import 'package:shopping/ui/items_screen.dart';

import 'model/shopping.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Shopping List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() {
    testDb();
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ShoppingList> shoppingLists;

  Future<void> loadLists() async {
    List<ShoppingList> loadedLists = await ShoppingList().select().orderBy('name').toList();
    setState(() {
      shoppingLists = loadedLists;
    });
  }

  @override
  void initState() {
    loadLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (shoppingLists != null) ? shoppingLists.length : 0,
      itemBuilder: (BuildContext context, int index) {
        final ShoppingList list = shoppingLists[index];
        return ListTile(
          title: Text(list.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ItemsScreen(list)),
            );
          },
          trailing: IconButton(
            icon: Icon(Icons.edit),
              onPressed: () {},
          ),
        );
      },
    );
  }
}

