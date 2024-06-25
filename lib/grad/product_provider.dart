import 'package:flutter/material.dart';
import 'dart:io';

class Product {
  final String name;
  final String description;
  final double price;
  final String stockStatus;
  final String category;
  final String subcategory;
  final File imageFile;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.stockStatus,
    required this.category,
    required this.subcategory,
    required this.imageFile,
  });
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}
