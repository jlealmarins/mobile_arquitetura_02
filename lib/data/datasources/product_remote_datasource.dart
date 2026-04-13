import 'package:atividade4/core/network/app_http_client.dart';
import 'package:atividade4/data/models/product_model.dart';

class ProductRemoteDatasource {
  final AppHttpClient client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get('https://fakestoreapi.com/products');
    final data = response as List<dynamic>;

    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
