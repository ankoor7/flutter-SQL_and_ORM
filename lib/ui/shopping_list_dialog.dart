import 'package:flutter/material.dart';
import 'package:shopping/model/shopping.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, { VoidCallback onSave }) {
    bool isNew = (list.id == null);

    if (list.name != null) {
      txtName.text = list.name;
    }

    if (list.priority != null) {
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      title: Text(
        isNew ? 'New Shopping List' : 'Edit Shopping List',
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Shopping List Name',
              ),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: txtPriority,
              decoration: InputDecoration(
                hintText: 'Shopping List Priority (1-3)',
              ),
              keyboardType: TextInputType.number,
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () async {
                list.name = txtName.text;
                int priority = int.tryParse(txtPriority.text);
                if (priority != null) {
                  list.priority = priority;
                }
                await list.upsert();

                Navigator.pop(context);

                if (onSave != null) {
                  onSave();
                }
              }
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
