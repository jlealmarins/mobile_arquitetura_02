import 'package:atividade4/domain/entities/product.dart';
import 'package:atividade4/domain/repositories/product_repository.dart';
import 'package:atividade4/main.dart';
import 'package:atividade4/presentation/viewmodels/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return const [
      Product(
        id: 1,
        title: 'Notebook Gamer',
        price: 5999.90,
        image: 'https://example.com/notebook.png',
      ),
    ];
  }
}

void main() {
  testWidgets('exibe a tela inicial de produtos', (WidgetTester tester) async {
    final viewModel = ProductViewModel(FakeProductRepository());
    await viewModel.loadProducts();

    await tester.pumpWidget(MyApp(viewModel: viewModel));
    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Notebook Gamer'), findsOneWidget);
    expect(find.text('R\$ 5999.90'), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });
}
