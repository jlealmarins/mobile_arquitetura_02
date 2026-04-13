import 'package:atividade4/data/datasources/product_remote_datasource.dart';
import 'package:atividade4/domain/entities/product.dart';
import 'package:atividade4/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await datasource.getProducts();
    return models.map((model) => model.toEntity()).toList();
  }
}
