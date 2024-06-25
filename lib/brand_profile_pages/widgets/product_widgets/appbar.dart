import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_share/flutter_share.dart';


class ProductAppBar extends StatelessWidget {

  const ProductAppBar({
    super.key,

  });

  Future<void> shareProduct() async {

    await FlutterShare.share(
        title: 'Check out this product',
        text: 'Check out this product: https://example.com/product/123',
        linkUrl: 'https://example.com/product/123',
        chooserTitle: 'Share using'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Ionicons.chevron_back),
          ),
          const Spacer(),

          IconButton(
            onPressed: shareProduct,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Ionicons.share_social_outline),
          ),

        ],
      ),
    );
  }
}