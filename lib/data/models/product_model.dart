import 'package:atividade4/domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.description = '',
    this.category = '',
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final price = json['price'];

    return ProductModel(
      id: id is int ? id : (id as num).toInt(),
      title: json['title'] as String,
      price: price is double ? price : (price as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
    );
  }
}
