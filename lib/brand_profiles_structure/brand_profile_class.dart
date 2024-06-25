import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../brand_profile_pages/screens/personal_brand_profile.dart';
import 'following_page.dart';

class BrandProfile extends StatelessWidget {
  final String logo;
  final String brandName;
  final String username;
  final String description;
  final String email;
  final String address;
  final String phone;
  final String item;
  final double rate;

  bool isFollowed = false;

  BrandProfile({
    required this.logo,
    required this.brandName,
    required this.username,
    required this.description,
    required this.email,
    required this.address,
    required this.phone,
    required this.item,
    required this.rate,
  });

  static List<BrandProfile> followedBrands = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
             brand: {}, brandId: '',
            ),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 320,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 165,
                child: Image.asset(logo, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brandName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Owner: $username',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Address: $address',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Item: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$item',
                          ),
                          TextSpan(
                            text: '   ',
                          ),
                          TextSpan(
                            text: 'Brand Description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Description"),
                                      content: Text(description),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 9.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isFollowed) {
                        isFollowed = true;
                        followedBrands.add(this);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FollowingPage(followedBrands: followedBrands),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('You have already followed this brand.'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: Text('Follow'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
