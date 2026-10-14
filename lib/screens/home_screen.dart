import 'package:flutter/material.dart';
import '../models/coffee_item.dart';
import '../services/quote_service.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final VoidCallback onBrowseMenu;
  final VoidCallback onBrowseQuotes;
  final VoidCallback onBrowseMusic;
  final ValueChanged<CoffeeItem> onAdd;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onBrowseMenu,
    required this.onBrowseQuotes,
    required this.onBrowseMusic,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final featured = coffeeMenu.take(2).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF160F20),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF633A91),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.coffee_rounded,
                      color: Color(0xFFFFB8DF),
                      size: 27,
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
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
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
                  const Icon(
                    Icons.local_cafe_rounded,
                    color: Color(0xFFFFA6D5),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Hello, $userName! â˜•',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Your little corner of comfort awaits.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF633A91),
                      Color(0xFF382052),
                      Color(0xFF42213F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR DAILY RITUAL',
                      style: TextStyle(
                        color: Color(0xFFFFB8DF),
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Slow mornings.\nWarm coffee.\nA softer kind of day.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: onBrowseMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA6D5),
                        foregroundColor: const Color(0xFF291536),
                      ),
                      child: const Text('Explore the menu'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _sectionTitle('A LITTLE INSPIRATION', 'For your day'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF281B36),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF513567)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFFFFA6D5),
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      QuoteService.randomQuote,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onBrowseQuotes,
                        child: const Text(
                          'More inspiration â†’',
                          style: TextStyle(color: Color(0xFFFFA6D5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _sectionTitle('COFFEE CORNER', 'Customer favorites'),
              const SizedBox(height: 12),
              ...featured.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 85,
                            height: 85,
                            color: const Color(0xFF633A91),
                            child: const Icon(
                              Icons.coffee,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
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
                            const SizedBox(height: 5),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'â‚±${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFFFFA6D5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => onAdd(item),
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          color: Color(0xFFFFA6D5),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _quickLink(
                icon: Icons.headphones_rounded,
                title: 'Music for your mood',
                subtitle: 'Find your cozy soundtrack',
                onTap: onBrowseMusic,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFA6D5),
            fontSize: 11,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _quickLink({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      tileColor: const Color(0xFF281B36),
      leading: Icon(icon, color: const Color(0xFFFFA6D5), size: 30),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white54,
        size: 16,
      ),
    );
  }
}


