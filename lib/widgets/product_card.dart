import 'package:flutter/material.dart';

import '../models/coffee_item.dart';

class ProductCard extends StatelessWidget {
  final CoffeeItem item;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF281B36),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF493454),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 112,
            child: _buildImage(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9, 7, 7, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₱${item.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFFFFA6D5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 29,
                        height: 29,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: onAdd,
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Color(0xFF21142F),
                            size: 19,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA6D5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageProvider = item.image.startsWith('assets/')
        ? AssetImage(item.image) as ImageProvider
        : NetworkImage(item.image);

    return Image(
      image: imageProvider,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF633A91),
          alignment: Alignment.center,
          child: const Icon(
            Icons.coffee_rounded,
            color: Colors.white,
            size: 32,
          ),
        );
      },
    );
  }
}