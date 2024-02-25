import 'package:flutter/material.dart';
import 'package:flutter_application_5/models/grocery_item.dart';
import 'package:flutter_application_5/widgets/new_item.dart';


class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You have no items added yet"));
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (_) {
            setState(() {
              _groceryItems.remove(_groceryItems[index]);

            });
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
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Grocery",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<GroceryItem>(
                          MaterialPageRoute(builder: (ctx) => const NewItem()))
                      .then((GroceryItem? value) {
                    if (value == null) return;
                    setState(() {
                      _groceryItems.add(value);
                    });
                  });
                },
                icon: const Icon(Icons.add),
                color: Colors.white)
          ],
        ),
        body: content);
  }
}
