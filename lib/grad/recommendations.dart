import 'package:flutter/material.dart';

class Recommendations extends StatefulWidget {
  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  List<Brand> brands = [];

  @override
  void initState() {
    super.initState();
    fetchBrands().then((value) {
      setState(() {
        brands = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome to Name',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              // Navigate back to the interests screen
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Recommended for you',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Here are some brands based on your interests',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 1,
                        color: const Color(0xFFEBF0FF),
                      ),
                      const SizedBox(height: 8),
                      ...brands.map((brand) => BrandCircle(
                            brand: brand,
                            onFollow: () {
                              setState(() {
                                brand.isFollowed = !brand.isFollowed;
                              });
                            },
                          )),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Continue', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF684399),
                          minimumSize: const Size(320, 37),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFFEBF0FF),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFFEBF0FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Brand>> fetchBrands() async {
    // Simulate a delay to mimic network request
    await Future.delayed(const Duration(seconds: 2));

    // Mock data
    List<Brand> mockBrands = [
      Brand(
        image: 'images/image-not-found.jpg',
        name: 'Brand 1',
        brief: 'Brief description 1',
        isFollowed: false,
      ),
      Brand(
        image: 'images/image-not-found.jpg',
        name: 'Brand 2',
        brief: 'Brief description 2',
        isFollowed: false,
      ),
      Brand(
        image: 'images/image-not-found.jpg',
        name: 'Brand 3',
        brief: 'Brief description 3',
        isFollowed: false,
      ),
      Brand(
        image: 'images/image-not-found.jpg',
        name: 'Brand 4',
        brief: 'Brief description 4',
        isFollowed: false,
      ),
      Brand(
        image: 'images/image-not-found.jpg',
        name: 'Brand 5',
        brief: 'Brief description 5',
        isFollowed: false,
      ),
    ];

    return mockBrands;
  }
}

class Brand {
  final String image;
  final String name;
  final String brief;
  bool isFollowed;

  Brand({
    required this.image,
    required this.name,
    required this.brief,
    required this.isFollowed,
  });
}

class BrandCircle extends StatelessWidget {
  final Brand brand;
  final VoidCallback onFollow;

  const BrandCircle({
    required this.brand,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(brand.image),
            radius: 50,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(brand.name),
              Text(brand.brief),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 40, // Adjust the height as needed
            child: Container(
              decoration: BoxDecoration(
                color: brand.isFollowed
                    ? const Color(0xFF684399).withOpacity(0.26)
                    : Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: OutlinedButton(
                onPressed: onFollow,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF684399)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  brand.isFollowed ? 'Following' : 'Follow',
                  style: const TextStyle(
                    color: Color(0xFF684399),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
