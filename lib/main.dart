import 'package:atividade4/screens/home_screen.dart';
import 'package:atividade4/services/product_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(productService: ProductService()));
}

class MyApp extends StatelessWidget {
  final ProductService productService;

  const MyApp({super.key, required this.productService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(productService: productService),
    );
  }
}
