import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../constants.dart';
import '../models/products.dart';
import '../screens/favorite_screen.dart';
import '../screens/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product1;

  const ProductCard({Key? key, required this.product1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductScreen(product: {}),
              ),
            );
          },
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kcontentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset(
                  product1.image,
                  width: 120,
                  height: 120,
                ),
                Text(
                  product1.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "\$${product1.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        product1.colors.length,
                            (cindex) => Container(
                          height: 15,
                          width: 15,
                          margin: const EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(
                            color: product1.colors[cindex],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                if (!FavoritePage.favoriteProducts.contains(product1)) {
                  FavoritePage.favoriteProducts.add(product1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product1.title} added to favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product1.title} is already in favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  Ionicons.heart_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}