import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({super.key, required this.onGetStarted});

  static const Color background = Color(0xFF463453);
  static const Color purple = Color(0xFFA970D8);
  static const Color pink = Color(0xFFFF9FD3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 42,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.local_cafe_rounded,
                            color: pink,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Text(
                          'BREW & BLOOM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 27),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: SizedBox(
                        height: constraints.maxHeight < 650 ? 230 : 320,
                        width: double.infinity,
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
                                  size: 100,
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
                                    background.withValues(alpha: 0.94),
                                  ],
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 20,
                              right: 20,
                              bottom: 23,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YOUR COZY LITTLE CAFE',
                                    style: TextStyle(
                                      color: pink,
                                      fontSize: 10,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Coffee, comfort,',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'and a little magic. ✨',
                                    style: TextStyle(
                                      color: pink,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Your moment. Your mood.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      'Discover lovely coffees, refreshing drinks, '
                      'sweet snacks, relaxing music, and little '
                      'reminders to enjoy your day.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 23),
                    Row(
                      children: [
                        _FeatureCard(
                          icon: Icons.coffee_rounded,
                          title: 'Coffee',
                          subtitle: 'Brewed with love',
                        ),
                        const SizedBox(width: 9),
                        _FeatureCard(
                          icon: Icons.bakery_dining_rounded,
                          title: 'Treats',
                          subtitle: 'Sweet little joys',
                        ),
                        const SizedBox(width: 9),
                        _FeatureCard(
                          icon: Icons.headphones_rounded,
                          title: 'Music',
                          subtitle: 'Find your mood',
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: onGetStarted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          foregroundColor: background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Made with ☕ using Flutter • Dart',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF61466D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF8C6B9A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFFF9FD3), size: 25),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
