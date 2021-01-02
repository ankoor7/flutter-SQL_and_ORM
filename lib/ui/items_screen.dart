import 'package:flutter/material.dart';
import 'package:shopping/model/shopping.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList list;

  const ItemsScreen(this.list);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(list);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList list;
  List<ListItem> items;
  _ItemsScreenState(this.list);

  Future<void> loadListItems() async {
    final loadedItems = await list.getListItems().toList(preload: true);
    setState(() {
      items = loadedItems;
    });
  }

  @override
  void initState() {
    loadListItems();
    super.initState();
  }

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text(list.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final ListItem item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity} - Note: ${item.note}'),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
