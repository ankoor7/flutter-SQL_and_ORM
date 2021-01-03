import 'package:flutter/material.dart';
import 'package:shopping/ui/items_screen.dart';
import 'package:shopping/ui/shopping_list_dialog.dart';

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
      home: ShList(title: 'Shopping List'),
    );
  }
}

class ShList extends StatefulWidget {
  ShList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ShoppingList> shoppingLists;
  ShoppingListDialog dialog;

  Future loadLists() async {
    List<ShoppingList> loadedLists =
        await ShoppingList().select().orderBy('name').toList();
    setState(() {
      shoppingLists = loadedLists;
    });
  }

  @override
  void initState() {
    dialog = ShoppingListDialog();
    loadLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: (shoppingLists != null) ? shoppingLists.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final ShoppingList list = shoppingLists[index];
          return Dismissible(
            key: Key('${list.id}:${list.name}'),
            onDismissed: (direction) async {
              String listName = list.name;
              await list.delete();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('$listName was deleted'),
              ));
              loadLists();
            },
            child: ListTile(
              title: Text(list.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ItemsScreen(list)),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialog.buildDialog(context, list, onSave: loadLists),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ShoppingList(), onSave: loadLists),
          );
        },
      ),
    );
  }
}
