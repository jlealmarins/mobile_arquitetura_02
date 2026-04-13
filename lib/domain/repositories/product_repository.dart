import 'package:atividade4/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
