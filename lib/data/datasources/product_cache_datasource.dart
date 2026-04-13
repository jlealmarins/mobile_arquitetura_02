import 'package:atividade4/data/models/product_model.dart';

class ProductCacheDatasource {
  List<ProductModel>? _cache;

  void save(List<ProductModel> products) {
    _cache = List.unmodifiable(products);
  }

  List<ProductModel>? get() {
    return _cache;
  }
}
