import 'package:flutter/material.dart';
import 'package:flutter_application_5/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255,49,57,59),
        colorScheme:  ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 147, 230, 247), surface: const Color.fromARGB(255, 44, 50, 60),
        brightness: Brightness.dark,),
        //useMaterial3: true,
      ),
      home: const GroceryList(),
    );
  }
}
