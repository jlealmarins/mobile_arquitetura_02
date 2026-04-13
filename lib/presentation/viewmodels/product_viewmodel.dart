import 'package:atividade4/domain/entities/product.dart';
import 'package:atividade4/domain/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';

class ProductViewModel {
  final ProductRepository repository;
  final ValueNotifier<List<Product>> products = ValueNotifier<List<Product>>(
    const [],
  );

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    try {
      final result = await repository.getProducts();
      products.value = result;
    } catch (error) {
      debugPrint('Erro ao carregar produtos: $error');
      products.value = const [];
    }
  }

  void dispose() {
    products.dispose();
  }
}
