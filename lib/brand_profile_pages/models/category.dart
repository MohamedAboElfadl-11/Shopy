class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categories = [
  Category(title: "Shoes", image: "images/image-not-found.jpg"),
  Category(title: "Beauty", image: "images/image-not-found.jpg"),
  Category(title: "Bags", image: "images/image-not-found.jpg"),
  Category(title: "Watch", image: "images/image-not-found.jpg"),
];
