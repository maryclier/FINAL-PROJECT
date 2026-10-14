import 'package:flutter/material.dart';
import '../models/coffee_item.dart';

class CartScreen extends StatelessWidget {
  final Map<CoffeeItem, int> cart;
  final ValueChanged<CoffeeItem> onIncrease;
  final ValueChanged<CoffeeItem> onDecrease;
  final VoidCallback onCheckout;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onIncrease,
    required this.onDecrease,
    required this.onCheckout,
  });

  double get subtotal {
    return cart.entries.fold(
      0,
      (total, entry) => total + entry.key.price * entry.value,
    );
  }

  int get itemCount {
    return cart.values.fold(0, (total, quantity) => total + quantity);
  }

  @override
  Widget build(BuildContext context) {
    final entries = cart.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF160F20),
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color(0xFF160F20),
      ),
      body: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Color(0xFFFFA6D5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your cart is waiting!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your favorite coffee and snacks from the menu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA6D5),
                        foregroundColor: const Color(0xFF21142F),
                      ),
                      child: const Text('Back to browsing'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final item = entry.key;
                      final quantity = entry.value;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF281B36),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.image,
                                width: 82,
                                height: 82,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 82,
                                  height: 82,
                                  color: const Color(0xFF633A91),
                                  child: const Icon(
                                    Icons.coffee_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'â‚±${item.price.toStringAsFixed(2)} each',
                                    style: const TextStyle(
                                      color: Color(0xFFFFA6D5),
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove,
                                        onTap: () => onDecrease(item),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      _quantityButton(
                                        icon: Icons.add,
                                        onTap: () => onIncrease(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'â‚±${(item.price * quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF281B36),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        _summaryRow('Items', '$itemCount'),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Subtotal',
                          'â‚±${subtotal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFF493454)),
                        const SizedBox(height: 12),
                        _summaryRow(
                          'Total',
                          'â‚±${subtotal.toStringAsFixed(2)}',
                          bold: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: onCheckout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFA6D5),
                              foregroundColor: const Color(0xFF21142F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Continue to Checkout',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF633A91),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 17),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? Colors.white : Colors.white70,
            fontSize: bold ? 17 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: bold ? const Color(0xFFFFA6D5) : Colors.white,
            fontSize: bold ? 19 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


