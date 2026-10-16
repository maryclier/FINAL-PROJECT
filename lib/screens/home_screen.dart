import 'package:flutter/material.dart';

import '../models/coffee_item.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final VoidCallback onBrowseMenu;
  final VoidCallback onBrowseQuotes;
  final VoidCallback onBrowseMusic;
  final void Function(CoffeeItem item) onAdd;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onBrowseMenu,
    required this.onBrowseQuotes,
    required this.onBrowseMusic,
    required this.onAdd,
  });

  static const Color background = Color(0xFF463453);
  static const Color cardColor = Color(0xFF61466D);
  static const Color purple = Color(0xFFA970D8);
  static const Color pink = Color(0xFFFF9FD3);

  @override
  Widget build(BuildContext context) {
    final favorites = coffeeMenu.take(4).toList();
    final firstName = userName.trim().isEmpty
        ? 'Coffee Lover'
        : userName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: purple,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.local_cafe_rounded,
                          color: pink,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BREW & BLOOM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Coffee, comfort and little joys',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onBrowseMenu,
                        icon: const Icon(
                          Icons.local_cafe_outlined,
                          color: pink,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Hello, $firstName! ☕',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Your little corner of comfort awaits.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 250,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=1000',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: purple,
                              child: const Icon(
                                Icons.coffee_rounded,
                                color: pink,
                                size: 90,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  background.withValues(alpha: 0.96),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pink,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'YOUR DAILY RITUAL',
                                    style: TextStyle(
                                      color: background,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Slow mornings.\nWarm coffee.\nA softer kind of day.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    height: 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton.icon(
                                    onPressed: onBrowseMenu,
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 17,
                                    ),
                                    label: const Text('Explore the menu'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: pink,
                                      foregroundColor: background,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 17,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 27),
                  const Text(
                    'A LITTLE INSPIRATION',
                    style: TextStyle(
                      color: pink,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'For your day ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: purple.withValues(alpha: 0.7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          color: pink,
                          size: 30,
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'A calm heart sees things more clearly.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: onBrowseQuotes,
                            child: const Text(
                              'More inspiration ✨',
                              style: TextStyle(color: pink),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COFFEE CORNER',
                            style: TextStyle(
                              color: pink,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Customer favorites',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: onBrowseMenu,
                        child: const Text(
                          'View all →',
                          style: TextStyle(color: pink),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...favorites.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 11),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: SizedBox(
                              width: 76,
                              height: 76,
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: purple,
                                  child: const Icon(
                                    Icons.local_cafe_rounded,
                                    color: pink,
                                    size: 30,
                                  ),
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
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₱${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: pink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Add to cart',
                            onPressed: () => onAdd(item),
                            style: IconButton.styleFrom(
                              backgroundColor: pink,
                              foregroundColor: background,
                            ),
                            icon: const Icon(Icons.add_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onBrowseMusic,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.headphones_rounded, color: pink, size: 31),
                          SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Music for your mood',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Find your cozy soundtrack',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: pink,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
