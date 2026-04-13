import 'package:atividade4/domain/repositories/product_repository.dart';
import 'package:atividade4/presentation/viewmodels/product_state.dart';
import 'package:flutter/foundation.dart';

class ProductViewModel {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);

    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (error) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  void dispose() {
    state.dispose();
  }
}
