import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../chat_screens/chats_screen.dart';
import 'brandProfile-brandView.dart';
import 'dashboard.dart';
import 'order.dart';
import 'AddProduct.dart';
import 'dart:io';

class Product {
  final String name;
  final String description;
  final double price;
  final String stockStatus;
  final String category;
  final String subcategory;
  final File imageFile; // Changed to File object

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.stockStatus,
    required this.category,
    required this.subcategory,
    required this.imageFile, // Changed to File object
  });
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Product> allProducts = [];

  List<Product> displayedProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(allProducts);
  }

  void _filterProducts(String query) {
    List<Product> filteredProducts = allProducts
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayedProducts = filteredProducts;
    });
  }

  void _openAddProductPage({Product? product}) async {
    final newProduct = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    ) as Product?;

    if (newProduct != null) {
      setState(() {
        // Check if product already exists in allProducts
        final existingProductIndex = allProducts.indexWhere((p) => p.name == newProduct.name);
        if (existingProductIndex != -1) {
          // Update existing product
          allProducts[existingProductIndex] = newProduct;
          displayedProducts[existingProductIndex] = Product(
            name: newProduct.name,
            description: newProduct.description,
            price: newProduct.price,
            stockStatus: newProduct.stockStatus,
            category: newProduct.category,
            subcategory: newProduct.subcategory,
            imageFile: newProduct.imageFile, // Keep the File object
          );
        } else {
          // Add new product
          allProducts.add(newProduct);
          displayedProducts.add(Product(
            name: newProduct.name,
            description: newProduct.description,
            price: newProduct.price,
            stockStatus: newProduct.stockStatus,
            category: newProduct.category,
            subcategory: newProduct.subcategory,
            imageFile: newProduct.imageFile, // Keep the File object
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF684399),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF684399)),
                      onChanged: _filterProducts,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF684399)),
                  onPressed: () => _openAddProductPage(),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedProducts.isEmpty
                ? const Center(
              child: Text(
                'No Products Added Yet',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _openAddProductPage(product: displayedProducts[index]),
                  leading: Image.file(
                    displayedProducts[index].imageFile, // Use the File object here
                    width: 50,
                    height: 50,
                  ),
                  title: Text(displayedProducts[index].name),
                  subtitle: Text(displayedProducts[index].stockStatus),
                  trailing: Text('\$${displayedProducts[index].price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: SalomonBottomBar(
          currentIndex: 3, // Set the correct index for the current page
          backgroundColor: Colors.white,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatsScreen()),
                ); // Add navigation logic for Messages page if you have one
                break;
              case 3:
              // Already on the Products page, no action needed
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
            }
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.receipt_long),
              title: const Text("Orders"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.message),
              title: const Text("Message"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.inventory_2, color: Color(0xFF684399)),
              title: const Text("Products", style: TextStyle(color: Color(0xFF684399))),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_circle),
              title: const Text("Account", style: TextStyle(color: Color(0xFF684399))),
            ),
          ],
        ),
      ),
    );
  }
}
