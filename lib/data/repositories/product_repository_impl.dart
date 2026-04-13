import 'package:atividade4/core/errors/failure.dart';
import 'package:atividade4/data/datasources/product_cache_datasource.dart';
import 'package:atividade4/data/datasources/product_remote_datasource.dart';
import 'package:atividade4/domain/entities/product.dart';
import 'package:atividade4/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);

      return models.map((model) => model.toEntity()).toList();
    } catch (error) {
      final cached = cache.get();

      if (cached != null) {
        return cached.map((model) => model.toEntity()).toList();
      }

      throw const Failure('Nao foi possivel carregar os produtos.');
    }
  }
}
