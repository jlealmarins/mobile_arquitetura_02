import 'package:atividade4/models/product.dart';
import 'package:atividade4/screens/product_detail_screen.dart';
import 'package:atividade4/screens/product_form_screen.dart';
import 'package:atividade4/services/product_service.dart';
import 'package:atividade4/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  final ProductService productService;

  const ProductListScreen({super.key, required this.productService});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  var _isLoading = true;
  String? _error;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await widget.productService.fetchProducts();

      if (!mounted) {
        return;
      }

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = 'Nao foi possivel carregar os produtos.';
        _isLoading = false;
      });
    }
  }

  Future<void> _openDetails(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  Future<void> _openForm([Product? product]) async {
    final savedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          productService: widget.productService,
          product: product,
        ),
      ),
    );

    if (savedProduct == null || !mounted) {
      return;
    }

    setState(() {
      final index = _products.indexWhere(
        (currentProduct) => currentProduct.id == savedProduct.id,
      );

      if (index >= 0) {
        _products[index] = savedProduct;
      } else {
        _products = [savedProduct, ..._products];
      }
    });

    _showMessage(
      product == null ? 'Produto cadastrado.' : 'Produto atualizado.',
    );
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja excluir "${product.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      final id = product.id;

      if (id != null) {
        await widget.productService.deleteProduct(id.toString());
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _products = _products
            .where((currentProduct) => currentProduct != product)
            .toList();
      });

      _showMessage('Produto excluido.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage('Erro ao excluir produto: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _loadProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Nenhum produto encontrado.'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = _products[index];

        return ProductCard(
          product: product,
          onTap: () => _openDetails(product),
          onEdit: () => _openForm(product),
          onDelete: () => _deleteProduct(product),
        );
      },
    );
  }
}
