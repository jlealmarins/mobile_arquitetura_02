import 'dart:convert';
import 'dart:io';

import 'package:atividade4/models/product.dart';

class ProductService {
  static const _baseUrl = 'https://fakestoreapi.com/products';

  final HttpClient _client;

  ProductService([HttpClient? client]) : _client = client ?? HttpClient();

  Future<List<Product>> fetchProducts() async {
    final response = await _send('GET', Uri.parse(_baseUrl));
    final data = response as List<dynamic>;

    return data
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await _send(
      'POST',
      Uri.parse(_baseUrl),
      body: product.toJson(),
    );

    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<Product> updateProduct(Product product) async {
    final id = product.id;

    if (id == null) {
      throw Exception('Produto sem id para atualizar.');
    }

    final response = await _send(
      'PUT',
      Uri.parse('$_baseUrl/$id'),
      body: product.toJson(),
    );

    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String id) async {
    await _send('DELETE', Uri.parse('$_baseUrl/$id'), allowEmptyBody: true);
  }

  Future<dynamic> _send(
    String method,
    Uri uri, {
    Map<String, dynamic>? body,
    bool allowEmptyBody = false,
  }) async {
    final request = await _client.openUrl(method, uri);

    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha na API. Status: ${response.statusCode}');
    }

    if (responseBody.isEmpty) {
      if (allowEmptyBody) {
        return null;
      }

      throw Exception('A API retornou uma resposta vazia.');
    }

    return jsonDecode(responseBody);
  }
}
