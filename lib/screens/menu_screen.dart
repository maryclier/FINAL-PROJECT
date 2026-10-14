import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  final void Function(CoffeeItem item) onAdd;

  const MenuScreen({
    super.key,
    required this.onAdd,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';

  final categories = ['All', 'Coffee', 'Drinks', 'Snacks'];

  @override
  Widget build(BuildContext context) {
    final products = selectedCategory == 'All'
        ? coffeeMenu
        : coffeeMenu
            .where((item) => item.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Menu ☕',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${products.length} items',
                style: const TextStyle(
                  color: Color(0xFFFFA6D5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 2, 16, 14),
            child: Text(
              'Little treats, lovely moments.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = selectedCategory == category;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => selectedCategory = category);
                  },
                  showCheckmark: false,
                  selectedColor: const Color(0xFF633A91),
                  backgroundColor: const Color(0xFF281B36),
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFFFFA6D5)
                        : const Color(0xFF493454),
                  ),
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFFFFA6D5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory == 'All'
                      ? 'All Products'
                      : selectedCategory,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${products.length} products',
                  style: const TextStyle(
                    color: Color(0xFFFFA6D5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
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

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 2, 14, 90),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 210,
                  ),
                  itemBuilder: (context, index) {
                    final item = products[index];

                    return ProductCard(
                      item: item,
                      onAdd: () => widget.onAdd(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}