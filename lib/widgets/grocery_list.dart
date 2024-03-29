import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_5/data/categories.dart';
import 'package:flutter_application_5/data/dummy_items.dart';
import 'package:flutter_application_5/models/category.dart';
import 'package:flutter_application_5/models/grocery_item.dart';
import 'package:flutter_application_5/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You have no items added yet"));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (_) {
            _removeItem(groceryItems[index]);
          },
          child: ListTile(
            title: Text(
              _groceryItems[index].name,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            leading: Container(
                height: 24,
                width: 24,
                color: _groceryItems[index].category.color),
            trailing: Text(_groceryItems[index].quantity.toString(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ),
      );
    }
    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Grocery",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                color: Colors.white)
          ],
        ),
        body: content);
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    final url = Uri.https('shop-44cef-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    setState(() {
      _groceryItems.remove(item);
    });

    final res = await http.delete(url);
    if (res.statusCode > 399) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("We could not delte the item")));
      setState(() {
        return setState(() {
          _groceryItems.insert(index, item);
        });
      });
    }
  }

  void _loadData() async {
    final url = Uri.parse(
        "https://shop-44cef-default-rtdb.firebaseio.com/shopping-list.json");
    final http.Response res = await http.get(url).catchError((_) {
      return http.Response('',400);
    });
    if (json.decode(res.body) == null) {
      // or      if (res.body == 'null')
      setState(() {
        _isLoading = false;
      });

      return;
    }

    final Map<String, dynamic> loadedData = json.decode(res.body);
    final List<GroceryItem> loadedItems = [];
    try {
      if (res.statusCode > 399) {
        setState(() {
          _error = 'Failed to fetch data, Please try again';
        });
        return;
      }
      for (var item in loadedData.entries) {
        final Category category = categories.entries
            .firstWhere(
                (element) => element.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));

        setState(() {
          _groceryItems = loadedItems;
          _isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        _error = 'Failed to fetch data, Please try again';
      });
    }
  }

  _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    _loadData();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }
}
