import 'dart:convert';
import 'dart:io';

import 'package:atividade4/core/errors/app_http_exception.dart';

class AppHttpClient {
  final HttpClient _client;

  AppHttpClient([HttpClient? client]) : _client = client ?? HttpClient();

  Future<dynamic> get(String url) async {
    final request = await _client.getUrl(Uri.parse(url));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AppHttpException(
        'Falha ao buscar produtos. Status: ${response.statusCode}',
      );
    }

    if (body.isEmpty) {
      throw const AppHttpException('A API retornou uma resposta vazia.');
    }

    return jsonDecode(body);
  }
}
