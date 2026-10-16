import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coffee_item.dart';

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  static const String _productsKey = 'brew_bloom_products_v1';
  static const String _deletedApiIdsKey = 'brew_bloom_deleted_api_ids_v1';
  static final Uri _productsUri = Uri.https(
    'dummyjson.com',
    '/products/search',
    {'q': 'coffee', 'limit': '100'},
  );

  final http.Client _client;

  Future<ProductCatalogResult> getProducts() async {
    final preferences = await SharedPreferences.getInstance();
    final savedProducts = preferences.getString(_productsKey);
    var products = _defaultProducts();
    String? cacheWarning;
    if (savedProducts != null) {
      try {
        products = (jsonDecode(savedProducts) as List<dynamic>)
            .map(
              (product) =>
                  CoffeeItem.fromJson(product as Map<String, dynamic>),
            )
            .toList();
      } on FormatException {
        cacheWarning = 'Saved menu data was damaged; restored the starter menu.';
      } on TypeError {
        cacheWarning = 'Saved menu data was damaged; restored the starter menu.';
      }

      if (cacheWarning != null) {
        products = _defaultProducts();
        await _saveProducts(products);
      }
    }

    try {
      final response = await _client
          .get(_productsUri)
          .timeout(const Duration(seconds: 15));
      _checkResponse(response);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final apiProducts = body['products'] as List<dynamic>;
      final deletedApiIds = preferences.getStringList(_deletedApiIdsKey) ?? [];

      for (final apiProduct in apiProducts) {
        final data = apiProduct as Map<String, dynamic>;
        final title = data['title'] as String? ?? '';
        final description = data['description'] as String? ?? '';
        if (!'$title $description'.toLowerCase().contains('coffee')) continue;

        final apiId = data['id'] as int?;
        if (apiId == null ||
            deletedApiIds.contains(apiId.toString()) ||
            products.any(
              (product) =>
                  product.apiId == apiId ||
                  product.name.toLowerCase() == title.toLowerCase(),
            )) {
          continue;
        }

        products.add(CoffeeItem.fromApiJson(data, localId: 1000000 + apiId));
      }

      await _saveProducts(products);
      return ProductCatalogResult(
        products: products,
        warning: cacheWarning,
      );
    } on ProductApiException catch (error) {
      return ProductCatalogResult(
        products: products,
        warning: _combineWarnings(
          cacheWarning,
          '${error.message} Showing the saved coffee menu.',
        ),
      );
    } on http.ClientException catch (error) {
      return ProductCatalogResult(
        products: products,
        warning: _combineWarnings(
          cacheWarning,
          'API unavailable: $error Showing the saved coffee menu.',
        ),
      );
    } on TimeoutException {
      return ProductCatalogResult(
        products: products,
        warning: _combineWarnings(
          cacheWarning,
          'API request timed out. Showing the saved coffee menu.',
        ),
      );
    } on FormatException catch (error) {
      return ProductCatalogResult(
        products: products,
        warning: _combineWarnings(
          cacheWarning,
          'Invalid product API response: $error',
        ),
      );
    } on TypeError catch (error) {
      return ProductCatalogResult(
        products: products,
        warning: _combineWarnings(
          cacheWarning,
          'Invalid product API response: $error',
        ),
      );
    }
  }

  Future<CoffeeItem> createProduct(CoffeeItem item) async {
    final products = (await getProducts()).products;
    final nextId = products.fold<int>(
      0,
      (highestId, product) => product.id != null && product.id! > highestId
          ? product.id!
          : highestId,
    );
    final savedProduct = CoffeeItem(
      id: nextId + 1,
      name: item.name,
      description: item.description,
      price: item.price,
      image: item.image,
      category: item.category,
      currencyCode: item.currencyCode,
    );
    await _saveProducts([savedProduct, ...products]);

    final response = await _sendRequest(
      _client.post(
        Uri.https('dummyjson.com', '/products/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toApiJson()),
      ),
    );
    late final Map<String, dynamic> apiProduct;
    try {
      apiProduct = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException catch (error) {
      throw ProductApiException(
        'The create API returned invalid data: $error',
        localChangeSaved: true,
      );
    } on TypeError catch (error) {
      throw ProductApiException(
        'The create API returned invalid data: $error',
        localChangeSaved: true,
      );
    }
    final persistedProduct = CoffeeItem(
      id: savedProduct.id,
      apiId: apiProduct['id'] as int?,
      name: savedProduct.name,
      description: savedProduct.description,
      price: savedProduct.price,
      image: savedProduct.image,
      category: savedProduct.category,
      currencyCode: savedProduct.currencyCode,
    );
    await _replaceProduct(persistedProduct);
    return persistedProduct;
  }

  Future<CoffeeItem> updateProduct(CoffeeItem item) async {
    final id = item.id;
    if (id == null) {
      throw const ProductApiException('This product has no local ID.');
    }

    await _replaceProduct(item);
    final apiId = item.apiId;
    if (apiId != null) {
      await _sendRequest(
        _client.put(
          Uri.https('dummyjson.com', '/products/$apiId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(item.toApiJson()),
        ),
      );
    }
    return item;
  }

  Future<void> deleteProduct(CoffeeItem item) async {
    final id = item.id;
    if (id == null) {
      throw const ProductApiException('This product has no local ID.');
    }

    final products = (await getProducts()).products;
    await _saveProducts(products.where((product) => product.id != id).toList());

    final apiId = item.apiId;
    if (apiId != null) {
      final preferences = await SharedPreferences.getInstance();
      final deletedApiIds = preferences.getStringList(_deletedApiIdsKey) ?? [];
      if (!deletedApiIds.contains(apiId.toString())) {
        deletedApiIds.add(apiId.toString());
        await preferences.setStringList(_deletedApiIdsKey, deletedApiIds);
      }
      await _sendRequest(
        _client.delete(Uri.https('dummyjson.com', '/products/$apiId')),
      );
    }
  }

  void close() => _client.close();

  List<CoffeeItem> _defaultProducts() => coffeeMenu.indexed
      .map(
        (entry) => CoffeeItem(
          id: entry.$1 + 1,
          name: entry.$2.name,
          description: entry.$2.description,
          price: entry.$2.price,
          image: entry.$2.image,
          category: entry.$2.category,
        ),
      )
      .toList();

  String _combineWarnings(String? first, String second) =>
      first == null ? second : '$first $second';

  Future<void> _replaceProduct(CoffeeItem updatedProduct) async {
    final products = (await getProducts()).products;
    await _saveProducts(
      products
          .map(
            (product) =>
                product.id == updatedProduct.id ? updatedProduct : product,
          )
          .toList(),
    );
  }

  Future<void> _saveProducts(List<CoffeeItem> products) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _productsKey,
      jsonEncode(products.map((product) => product.toJson()).toList()),
    );
    if (!saved) {
      throw const ProductApiException(
        'Could not save products on this device.',
      );
    }
  }

  Future<http.Response> _sendRequest(Future<http.Response> request) async {
    try {
      final response = await request.timeout(const Duration(seconds: 15));
      _checkResponse(response);
      return response;
    } on ProductApiException catch (error) {
      throw ProductApiException(error.message, localChangeSaved: true);
    } on http.ClientException catch (error) {
      throw ProductApiException(
        'API sync failed: $error',
        localChangeSaved: true,
      );
    } on TimeoutException {
      throw const ProductApiException(
        'API sync timed out. Your change is saved on this device.',
        localChangeSaved: true,
      );
    }
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProductApiException(
        'The product API returned an error (${response.statusCode}).',
      );
    }
  }
}

class ProductApiException implements Exception {
  const ProductApiException(this.message, {this.localChangeSaved = false});

  final String message;
  final bool localChangeSaved;

  @override
  String toString() => message;
}

class ProductCatalogResult {
  const ProductCatalogResult({required this.products, this.warning});

  final List<CoffeeItem> products;
  final String? warning;
}
