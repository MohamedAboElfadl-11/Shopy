import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../models/cart_item.dart';
import '../models/products.dart'; // Assuming you have a Product model
import '../screens/product_screen.dart';
import '../screens/favorite_screen.dart'; // Import AddToCart widget

class CategoryPage extends StatelessWidget {
  final String category;
  final List<Product> products;
  final FavoritePage favoritePage = FavoritePage();

  CategoryPage({Key? key, required this.category, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onAddToCart(CartItem cartItem) {
      bool alreadyExists = cartItems.any((item) => item.product == cartItem.product);
      if (!alreadyExists) {
        cartItems.add(cartItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.product.title} added to shopping cart'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.product.title} is already in the shopping cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    void onAddToFavorites(Product product) {
      bool alreadyExists = FavoritePage.favoriteProducts.any((favProduct) => favProduct == product);
      if (!alreadyExists) {
        FavoritePage.favoriteProducts.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.title} added to favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.title} is already in favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            for (final product in products)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 390, // Set a fixed width for the card
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                product.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () {
                            onAddToFavorites(product);
                          },
                          icon: Icon(
                            Ionicons.heart_outline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                onAddToCart(CartItem(quantity: 1, product: product));
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(product: {}),
                                  ),
                                );
                              },
                              child: Text(
                                'See More',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}