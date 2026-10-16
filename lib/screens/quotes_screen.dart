import 'package:flutter/material.dart';

import '../services/quote_service.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  String quote = QuoteService.randomQuote;

  void changeQuote() {
    setState(() {
      quote = QuoteService.randomQuote;
    });
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFFB57AE5);
    const pink = Color(0xFFFF9FD3);

    return Scaffold(
      backgroundColor: const Color(0xFF463453),
      appBar: AppBar(
        title: const Text('Daily Inspiration'),
        backgroundColor: const Color(0xFF463453),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF765089), Color(0xFF58406B)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: purple),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.format_quote_rounded, color: pink, size: 58),
                const SizedBox(height: 20),
                const Text(
                  'A LITTLE REMINDER',
                  style: TextStyle(
                    color: pink,
                    fontSize: 12,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sip slowly. Breathe deeply. Keep growing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: changeQuote,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Another Quote'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
