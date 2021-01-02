import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'shopping.g.dart';

Future testDb() async {
  ShoppingList list = ShoppingList.fromMap({
    'name': 'shopping',
    'priority': 1,
    'id': 1,
  });

  await list.upsert();

  ListItem item1 = ListItem.fromMap({
    'name': 'apples',
    'quantity': '2',
    'note': 'better if green',
    'shoppingListId': list.id,
  });

  await item1.upsert();

  print(await list.toJsonWithChilds());
  print(item1.toJson());
}
// 'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER'
const SqfEntityTable tableShoppingList = SqfEntityTable(
  tableName: 'shoppingList',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('priority', DbType.integer),
  ]
);

// 'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT,
// quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES shoppingList(id))'
const SqfEntityTable tableListItem = SqfEntityTable(
  tableName: 'listItem',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('quantity', DbType.text),
    SqfEntityField('note', DbType.text),
    SqfEntityFieldRelationship(
      parentTable: tableShoppingList,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: 0
    ),
  ]
);

@SqfEntityBuilder(shoppingModel)
const shoppingModel = SqfEntityModel(
  modelName: 'shoppingModel',
  databaseName: 'shopping.db',
  password: null,
  databaseTables: [tableShoppingList, tableListItem],
  bundledDatabasePath: null,
);
