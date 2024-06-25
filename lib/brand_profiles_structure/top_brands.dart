import 'package:flutter/material.dart';

import 'brand_profile_class.dart';

class TopBrands extends StatefulWidget {
  const TopBrands({Key? key}) : super(key: key);

  @override
  _TopBrandsState createState() => _TopBrandsState();
}

class _TopBrandsState extends State<TopBrands> {
  final List<BrandProfile> _brandProfiles = [
    BrandProfile(
      logo: "images/image-not-found.jpg",
      brandName: "Handmade",
      username: "Fatma Muhammad",
      email: "fatma@gmail.com",
      address: "Zamalek",
      phone: "01221515704",
      item: "Tote Bag",
      description:
          "Hello HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello",
      rate: 100,
    ),
    BrandProfile(
      logo: "images/image-not-found.jpg",
      brandName: "Fashion",
      username: "Fatma Muhammad",
      email: "fatma@gmail.com",
      address: "Zamalek",
      phone: "01221515704",
      item: "Woman Sweater",
      description:
          "Hello HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello",
      rate: 350,
    ),
    BrandProfile(
      logo: "images/image-not-found.jpg",
      brandName: "Jewellery",
      username: "Fatma Muhammad",
      email: "fatma@gmail.com",
      address: "Zamalek",
      phone: "01221515704",
      item: "Accessories",
      description: "Hello",
      rate: 1000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sort the brand profiles based on rate
    _brandProfiles.sort((a, b) => b.rate.compareTo(a.rate));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Top Brands',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _brandProfiles.length,
        itemBuilder: (context, index) {
          final brandProfile = _brandProfiles[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: brandProfile,
          );
        },
      ),
    );
  }
}
