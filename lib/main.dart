import 'package:atividade4/core/network/app_http_client.dart';
import 'package:atividade4/data/datasources/product_cache_datasource.dart';
import 'package:atividade4/data/datasources/product_remote_datasource.dart';
import 'package:atividade4/data/repositories/product_repository_impl.dart';
import 'package:atividade4/presentation/pages/product_page.dart';
import 'package:atividade4/presentation/viewmodels/product_viewmodel.dart';
import 'package:flutter/material.dart';

void main() {
  final client = AppHttpClient();
  final remoteDatasource = ProductRemoteDatasource(client);
  final cacheDatasource = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(remoteDatasource, cacheDatasource);
  final viewModel = ProductViewModel(repository);

  viewModel.loadProducts();

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: ProductPage(viewModel: viewModel),
    );
  }
}
