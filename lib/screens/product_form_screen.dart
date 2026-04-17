import 'package:atividade4/models/product.dart';
import 'package:atividade4/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductService productService;
  final Product? product;

  const ProductFormScreen({
    super.key,
    required this.productService,
    this.product,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageController;
  var _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _titleController = TextEditingController(text: product?.title ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _categoryController = TextEditingController(text: product?.category ?? '');
    _imageController = TextEditingController(text: product?.image ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: widget.product?.id,
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.replaceAll(',', '.')),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      image: _imageController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final savedProduct = _isEditing
          ? await widget.productService.updateProduct(product)
          : await widget.productService.addProduct(product);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, savedProduct);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar produto: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar produto' : 'Novo produto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Preco',
              ),
              keyboardType: TextInputType.number,
              validator: _priceValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Descricao',
              ),
              maxLines: 4,
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Categoria',
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'URL da imagem',
              ),
              validator: _requiredValidator,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatorio.';
    }

    return null;
  }

  String? _priceValidator(String? value) {
    final normalizedValue = value?.replaceAll(',', '.');
    final price = double.tryParse(normalizedValue ?? '');

    if (price == null || price <= 0) {
      return 'Informe um preco valido.';
    }

    return null;
  }
}
