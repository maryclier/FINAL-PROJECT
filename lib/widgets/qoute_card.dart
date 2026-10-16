import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final VoidCallback? onNext;

  const QuoteCard({
    super.key,
    required this.quote,
    this.author = 'Brew & Bloom',
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA970D8), Color(0xFF724E84)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB88AE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Color(0xFFFF9FD3),
            size: 35,
          ),
          const SizedBox(height: 12),
          Text(
            quote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '— $author',
            style: const TextStyle(
              color: Color(0xFFFFC0E3),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onNext != null) ...[
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Another quote'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFFF9FD3)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
