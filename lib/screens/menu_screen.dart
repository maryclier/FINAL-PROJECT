import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  final ValueChanged<CoffeeItem> onAdd;

  const MenuScreen({
    super.key,
    required this.onAdd,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Coffee',
    'Drinks',
    'Snacks',
  ];

  List<CoffeeItem> get filteredItems {
    if (selectedCategory == 'All') {
      return coffeeMenu;
    }

    if (selectedCategory == 'Snacks') {
      return coffeeMenu
          .where((item) => item.category.toLowerCase() == 'snack' ||
              item.category.toLowerCase() == 'snacks')
          .toList();
    }

    return coffeeMenu
        .where((item) =>
            item.category.toLowerCase() == selectedCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFF160F20),
      appBar: AppBar(
        title: const Text(
          'Our Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF160F20),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Icon(
              Icons.local_cafe_rounded,
              color: const Color(0xFFFFA6D5),
              size: 27,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF633A91),
                      Color(0xFF392348),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A little sip of happiness',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Coffee, refreshing drinks, and sweet treats made for you.',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: const Color(0xFF281B36),
                    selectedColor: const Color(0xFFFFA6D5),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF21142F)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFFFA6D5)
                          : const Color(0xFF493454),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == 'All'
                        ? 'Everything you love'
                        : selectedCategory == 'Snacks'
                            ? 'Sweet little treats'
                            : selectedCategory == 'Drinks'
                                ? 'Refreshing drinks'
                                : 'Coffee favorites',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${items.length} items',
                    style: const TextStyle(
                      color: Color(0xFFFFA6D5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_drink_rounded,
                              size: 58,
                              color: Color(0xFFFFA6D5),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'More lovely drinks are coming!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try another category for now.',
                              style: TextStyle(color: Colors.white60),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategory = 'All';
                                });
                              },
                              child: const Text(
                                'Browse all items',
                                style: TextStyle(
                                  color: Color(0xFFFFA6D5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 13,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return ProductCard(
                          item: item,
                          onAdd: () => widget.onAdd(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}