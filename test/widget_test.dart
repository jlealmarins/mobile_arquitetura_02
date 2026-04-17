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
        description: 'Notebook com placa de video dedicada.',
        category: 'eletronicos',
        image: 'https://example.com/notebook.png',
      ),
    ];
  }
}

void main() {
  testWidgets('navega da tela inicial aos detalhes do produto', (
    WidgetTester tester,
  ) async {
    final viewModel = ProductViewModel(FakeProductRepository());
    await viewModel.loadProducts();

    await tester.pumpWidget(MyApp(viewModel: viewModel));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Loja de Produtos'), findsOneWidget);

    await tester.tap(find.text('Ver produtos'));
    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Notebook Gamer'), findsOneWidget);
    expect(find.text('R\$ 5999.90'), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);

    await tester.tap(find.text('Notebook Gamer'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes'), findsOneWidget);
    expect(find.text('ELETRONICOS'), findsOneWidget);
    expect(find.text('Descricao'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Notebook com placa de video dedicada.'),
      100,
    );
    expect(find.text('Notebook com placa de video dedicada.'), findsOneWidget);

    final backButton = find.widgetWithText(
      OutlinedButton,
      'Voltar para produtos',
    );

    await tester.scrollUntilVisible(backButton, 100);
    await tester.drag(find.byType(ListView), const Offset(0, -80));
    await tester.pumpAndSettle();
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
  });
}
