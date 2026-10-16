import 'package:flutter/material.dart';

import '../models/coffee_item.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  final void Function(CoffeeItem item) onAdd;

  const MenuScreen({super.key, required this.onAdd});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  List<CoffeeItem> _products = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String? _error;
  String? _apiWarning;
  bool _loading = true;
  bool _saving = false;

  List<String> get _categories => [
    'All',
    ..._products.map((item) => item.category).toSet().toList()..sort(),
  ];

  List<CoffeeItem> get _visibleProducts => _products.where((item) {
    final matchesCategory =
        _selectedCategory == 'All' || item.category == _selectedCategory;
    final query = _searchQuery.trim().toLowerCase();
    final matchesSearch =
        query.isEmpty ||
        item.name.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query);
    return matchesCategory && matchesSearch;
  }).toList();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productService.close();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _productService.getProducts();
      if (!mounted) return;
      setState(() {
        _products = result.products;
        _apiWarning = result.warning;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load products. $error';
        _loading = false;
      });
    }
  }

  Future<void> _openProductForm({CoffeeItem? product}) async {
    final result = await showDialog<CoffeeItem>(
      context: context,
      builder: (_) => _ProductFormDialog(product: product),
    );
    if (result == null || !mounted) return;

    setState(() => _saving = true);
    try {
      final saved = product == null
          ? await _productService.createProduct(result)
          : await _productService.updateProduct(result);
      if (!mounted) return;
      setState(() {
        if (product == null) {
          _products = [saved, ..._products];
        } else {
          _products = _products
              .map((item) => item.id == saved.id ? saved : item)
              .toList();
        }
        _saving = false;
      });
      final message = product == null
          ? 'Product created and saved on this device.'
          : saved.apiId == null
          ? 'Product updated and saved on this device.'
          : 'Product updated locally; demo API request sent.';
      _showMessage(message);
    } catch (error) {
      if (!mounted) return;
      if (error is ProductApiException && error.localChangeSaved) {
        final result = await _productService.getProducts();
        if (!mounted) return;
        setState(() {
          _products = result.products;
          _apiWarning = result.warning;
          _saving = false;
        });
        _showMessage('Saved on this device. API sync failed: ${error.message}');
      } else {
        setState(() => _saving = false);
        _showMessage('Could not save product. $error');
      }
    }
  }

  Future<void> _deleteProduct(CoffeeItem product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('“${product.name}” will be removed from this menu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB83D70),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await _productService.deleteProduct(product);
      if (!mounted) return;
      setState(() {
        _products.removeWhere((item) => item.id == product.id);
        _saving = false;
      });
      _showMessage('Product deleted from your saved menu.');
    } catch (error) {
      if (!mounted) return;
      if (error is ProductApiException && error.localChangeSaved) {
        final result = await _productService.getProducts();
        if (!mounted) return;
        setState(() {
          _products = result.products;
          _apiWarning = result.warning;
          _saving = false;
        });
        _showMessage(
          'Deleted on this device. API sync failed: ${error.message}',
        );
      } else {
        setState(() => _saving = false);
        _showMessage('Could not delete product. $error');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF8C6B9A),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The menu', style: TextStyle(fontWeight: FontWeight.w900)),
            Text(
              'GOOD COFFEE, GOOD MOOD',
              style: TextStyle(
                color: Color(0xFFFF9FD3),
                fontSize: 9,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh coffee API',
            onPressed: _loading ? null : _loadProducts,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: FilledButton.icon(
              onPressed: _saving ? null : () => _openProductForm(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF9FD3),
                foregroundColor: const Color(0xFF2C2035),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              child: _DemoNotice(
                warning: _apiWarning,
                onRetry: _loadProducts,
                isLoading: _loading,
                apiProducts: _products
                    .where((product) => product.apiId != null)
                    .length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Find your next favorite...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: const Color(0xFF61466D),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (!_loading && _error == null)
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final selected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Text(
                        category == 'All'
                            ? 'Everything'
                            : category.replaceAll('-', ' '),
                      ),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                      showCheckmark: false,
                      selectedColor: const Color(0xFFA970D8),
                      backgroundColor: const Color(0xFF61466D),
                      side: BorderSide(
                        color: selected
                            ? const Color(0xFFFF9FD3)
                            : const Color(0xFF8C6B9A),
                      ),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 11),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Made for your moment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _loading ? 'Loading...' : '${products.length} items',
                    style: const TextStyle(
                      color: Color(0xFFFF9FD3),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildContent(products)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<CoffeeItem> products) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9FD3)),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFFF9FD3),
                size: 42,
              ),
              const SizedBox(height: 14),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.coffee_rounded,
                color: Color(0xFFFF9FD3),
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isEmpty
                    ? 'Nothing on the menu yet.'
                    : 'No products match “$_searchQuery”.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1400
            ? 6
            : width >= 1100
            ? 5
            : width >= 800
            ? 4
            : width >= 520
            ? 3
            : 2;
        return RefreshIndicator(
          onRefresh: _loadProducts,
          color: const Color(0xFFFF9FD3),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 100),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 235,
            ),
            itemBuilder: (context, index) {
              final item = products[index];
              return IgnorePointer(
                ignoring: _saving,
                child: ProductCard(
                  item: item,
                  onAdd: () => widget.onAdd(item),
                  onEdit: () => _openProductForm(product: item),
                  onDelete: () => _deleteProduct(item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({
    required this.warning,
    required this.onRetry,
    required this.isLoading,
    required this.apiProducts,
  });

  final String? warning;
  final VoidCallback onRetry;
  final bool isLoading;
  final int apiProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF61466D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8C6B9A)),
      ),
      child: Row(
        children: [
          Icon(
            warning == null
                ? Icons.cloud_done_rounded
                : Icons.cloud_off_rounded,
            color: Color(0xFFFF9FD3),
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              warning ??
                  'Coffee API connected · $apiProducts API item(s) · edits saved on this device.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ),
          if (warning != null)
            IconButton(
              tooltip: 'Retry API',
              onPressed: isLoading ? null : onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFF9FD3)),
            ),
        ],
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({this.product});

  final CoffeeItem? product;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    _imageController = TextEditingController(text: product?.image ?? '');
    _categoryController = TextEditingController(
      text: product?.category ?? 'Coffee',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      CoffeeItem(
        id: widget.product?.id,
        apiId: widget.product?.apiId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        image: _imageController.text.trim(),
        category: _categoryController.text.trim(),
        currencyCode: widget.product?.currencyCode ?? 'PHP',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add a product' : 'Edit product'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _required,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: _required,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final price = double.tryParse(value?.trim() ?? '');
                    if (price == null || price <= 0) {
                      return 'Enter a price greater than zero.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: _required,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                  ),
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.product == null ? 'Create' : 'Save changes'),
        ),
      ],
    );
  }
}
