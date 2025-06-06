class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'image': image,
        'description': description,
        'category': category,
        'rating': {
          'rate': rate,
          'count': count,
        }
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>? ?? {};

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rate: (rating['rate'] ?? 0).toDouble(),
      count: (rating['count'] ?? 0).toInt(),
    );
  }
}
