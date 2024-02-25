import '../data/categories.dart';
import '../models/category.dart';
import '../models/grocery_item.dart';

final List<GroceryItem> groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
   GroceryItem(
      id: 'd',
      name: 'Cake',
      quantity: 2,
      category: categories[Categories.sweets]!),
   GroceryItem(
      id: 'e',
      name: 'Potatos',
      quantity: 3,
      category: categories[Categories.vegetables]!),
];
