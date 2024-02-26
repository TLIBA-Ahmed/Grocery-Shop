import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_5/data/categories.dart';
import 'package:flutter_application_5/models/category.dart';
import 'package:flutter_application_5/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  String _enteredName = "";
  int _enteredQuantity = 0;
  var _selectedCategory = categories[Categories.fruit]!;
  bool _isLoading = false;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final Uri url = Uri.parse(
          "https://shop-44cef-default-rtdb.firebaseio.com/shopping-list.json");
      http
          .post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'name': _enteredName,
                'quantity': _enteredQuantity,
                'category': _selectedCategory.title
              }))
          .then((res) {
        final Map<String, dynamic> resData = json.decode(res.body);
        if (res.statusCode == 200) {
          Navigator.of(context).pop(GroceryItem(
              id: resData['name'],
              name: _enteredName,
              quantity: _enteredQuantity,
              category: _selectedCategory));
        }
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add New Item",
                style: TextStyle(color: Colors.white))),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      onSaved: (newValue) {
                        _enteredName = newValue!;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white)),
                      validator: (String? value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 2 ||
                            value.trim().length > 49) {
                          return 'Error';
                        }
                        return null;
                      },
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Expanded(
                          child: TextFormField(
                        initialValue: '1',
                        onSaved: (newValue) {
                          _enteredQuantity = int.parse(newValue!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 1) {
                            return 'Error';
                          }
                          return null;
                        },
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: DropdownButtonFormField<Category>(
                        //hint: const Text('Select a category',style: TextStyle(color: Colors.white),),
                        value: _selectedCategory,
                        items: [
                          for (final cat in categories.entries)
                            DropdownMenuItem(
                                value: cat.value,
                                child: Row(children: [
                                  Container(
                                      height: 16,
                                      width: 16,
                                      color: cat.value.color),
                                  const SizedBox(width: 6),
                                  Text(cat.value.title)
                                ]))
                        ],
                        onChanged: (Category? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ))
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _formKey.currentState!.reset();
                                  },
                            child: const Text("Reset")),
                        ElevatedButton(
                            onPressed: _isLoading ? null : _saveItem,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator())
                                : const Text("Add Item"))
                      ],
                    )
                  ],
                ))));
  }
}
