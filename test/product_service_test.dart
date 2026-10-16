import 'dart:convert';

import 'package:brew_and_bloom/models/coffee_item.dart';
import 'package:brew_and_bloom/services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

http.Response _catalogResponse() => http.Response(
  jsonEncode({
    'products': [
      {
        'id': 34,
        'title': 'Nescafe Coffee',
        'description': 'Instant coffee made from roasted coffee beans',
        'price': 7.99,
        'thumbnail': 'https://example.com/coffee.jpg',
        'category': 'groceries',
      },
      {
        'id': 5,
        'title': 'Random Phone',
        'description': 'An unrelated product',
        'price': 50,
        'thumbnail': 'https://example.com/phone.jpg',
        'category': 'electronics',
      },
    ],
  }),
  200,
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProductService', () {
    test('fetches coffee from API and filters unrelated products', () async {
      http.Request? catalogRequest;
      final service = ProductService(
        client: MockClient((request) async {
          catalogRequest = request;
          return _catalogResponse();
        }),
      );

      final result = await service.getProducts();
      final apiCoffee = result.products.singleWhere(
        (product) => product.apiId == 34,
      );

      expect(catalogRequest?.method, 'GET');
      expect(catalogRequest?.url.host, 'dummyjson.com');
      expect(catalogRequest?.url.path, '/products/search');
      expect(catalogRequest?.url.queryParameters['q'], 'coffee');
      expect(result.warning, isNull);
      expect(apiCoffee.name, 'Nescafe Coffee');
      expect(apiCoffee.category, 'Coffee');
      expect(
        result.products.any((product) => product.name == 'Random Phone'),
        isFalse,
      );
      expect(result.products.length, coffeeMenu.length + 1);
      service.close();
    });

    test('uses the saved coffee catalog if the API is unavailable', () async {
      final service = ProductService(
        client: MockClient((_) async => http.Response('Unavailable', 503)),
      );

      final result = await service.getProducts();

      expect(result.products, hasLength(coffeeMenu.length));
      expect(result.products.first.name, 'Lavender Latte');
      expect(result.warning, contains('503'));
      service.close();
    });

    test(
      'recovers from corrupted saved products when the API is unavailable',
      () async {
        final preferences = await SharedPreferences.getInstance();
        final service = ProductService(
          client: MockClient((_) async => http.Response('Unavailable', 503)),
        );

        for (final damagedData in ['{invalid json', '{}']) {
          await preferences.setString('brew_bloom_products_v1', damagedData);
          final result = await service.getProducts();
          final repairedProducts = jsonDecode(
            preferences.getString('brew_bloom_products_v1')!,
          ) as List<dynamic>;

          expect(result.products, hasLength(coffeeMenu.length));
          expect(result.warning, contains('Saved menu data was damaged'));
          expect(result.warning, contains('503'));
          expect(repairedProducts, hasLength(coffeeMenu.length));
        }

        service.close();
      },
    );

    test('creates, updates, and deletes a product through the API', () async {
      final requests = <String>[];
      final service = ProductService(
        client: MockClient((request) async {
          requests.add('${request.method} ${request.url.path}');
          if (request.method == 'GET') return _catalogResponse();
          if (request.method == 'DELETE') {
            return http.Response('{"isDeleted":true}', 200);
          }

          final body = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(jsonEncode({...body, 'id': 212}), 200);
        }),
      );
      const product = CoffeeItem(
        name: 'Rose Latte',
        description: 'Floral espresso and milk',
        price: 145,
        image: '',
        category: 'Coffee',
      );

      final created = await service.createProduct(product);
      final updated = await service.updateProduct(
        CoffeeItem(
          id: created.id,
          apiId: created.apiId,
          name: 'Iced Rose Latte',
          description: product.description,
          price: 155,
          image: product.image,
          category: product.category,
        ),
      );
      await service.deleteProduct(updated);

      expect(created.apiId, 212);
      expect(updated.name, 'Iced Rose Latte');
      expect(requests, contains('PUT /products/212'));
      expect(requests, contains('DELETE /products/212'));
      final afterDeletingCreated = (await service.getProducts()).products;
      final apiCoffee = afterDeletingCreated.singleWhere(
        (item) => item.apiId == 34,
      );
      await service.deleteProduct(apiCoffee);
      final remaining = (await service.getProducts()).products;
      expect(remaining.any((item) => item.id == created.id), isFalse);
      expect(remaining.any((item) => item.apiId == 34), isFalse);
      expect(requests, contains('DELETE /products/34'));
      service.close();
    });

    test(
      'persists created and edited products after reloading the service',
      () async {
        final service = ProductService(
          client: MockClient((request) async {
            if (request.method == 'GET') return _catalogResponse();
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            return http.Response(jsonEncode({...body, 'id': 100}), 200);
          }),
        );
        const product = CoffeeItem(
          name: 'Honey Oat Latte',
          description: 'Espresso with oat milk and honey',
          price: 155,
          image: '',
          category: 'Coffee',
        );

        final created = await service.createProduct(product);
        final edited = CoffeeItem(
          id: created.id,
          apiId: created.apiId,
          name: 'Iced Honey Oat Latte',
          description: created.description,
          price: 165,
          image: created.image,
          category: created.category,
        );
        await service.updateProduct(edited);
        service.close();

        final reloadedService = ProductService(
          client: MockClient((_) async => _catalogResponse()),
        );
        final reloadedProducts = (await reloadedService.getProducts()).products;
        final reloadedProduct = reloadedProducts.singleWhere(
          (item) => item.id == edited.id,
        );

        expect(reloadedProduct.name, 'Iced Honey Oat Latte');
        expect(reloadedProduct.price, 165);
        reloadedService.close();
      },
    );

    test('keeps local changes and reports when an API write fails', () async {
      final service = ProductService(
        client: MockClient((_) async => http.Response('Unavailable', 503)),
      );
      const product = CoffeeItem(
        name: 'Vanilla Latte',
        description: 'Espresso with vanilla',
        price: 135,
        image: '',
        category: 'Coffee',
      );

      await expectLater(
        service.createProduct(product),
        throwsA(
          isA<ProductApiException>().having(
            (error) => error.localChangeSaved,
            'localChangeSaved',
            isTrue,
          ),
        ),
      );
      final result = await service.getProducts();
      expect(
        result.products.any((item) => item.name == 'Vanilla Latte'),
        isTrue,
      );
      service.close();
    });
  });
}
