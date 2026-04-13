import 'package:atividade4/core/errors/failure.dart';
import 'package:atividade4/core/network/app_http_client.dart';
import 'package:atividade4/data/datasources/product_cache_datasource.dart';
import 'package:atividade4/data/datasources/product_remote_datasource.dart';
import 'package:atividade4/data/models/product_model.dart';
import 'package:atividade4/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'usa cache quando a API falha depois de uma carga com sucesso',
    () async {
      final remote = _FakeRemoteDatasource([
        _products,
        Exception('Sem conexao'),
      ]);
      final cache = ProductCacheDatasource();
      final repository = ProductRepositoryImpl(remote, cache);

      final firstResult = await repository.getProducts();
      final cachedResult = await repository.getProducts();

      expect(firstResult.single.title, 'Produto em cache');
      expect(cachedResult.single.title, 'Produto em cache');
    },
  );

  test('lanca Failure quando a API falha e nao existe cache', () async {
    final remote = _FakeRemoteDatasource([Exception('Sem conexao')]);
    final cache = ProductCacheDatasource();
    final repository = ProductRepositoryImpl(remote, cache);

    expect(repository.getProducts, throwsA(isA<Failure>()));
  });
}

const _products = [
  ProductModel(
    id: 1,
    title: 'Produto em cache',
    price: 49.90,
    image: 'https://example.com/product.png',
  ),
];

class _FakeRemoteDatasource extends ProductRemoteDatasource {
  _FakeRemoteDatasource(this._responses) : super(AppHttpClient());

  final List<Object> _responses;
  var _currentIndex = 0;

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = _responses[_currentIndex];
    _currentIndex++;

    if (response is Exception) {
      throw response;
    }

    return response as List<ProductModel>;
  }
}
