import 'package:flutter/material.dart';

import '../models/coffee_item.dart';

class ProductCard extends StatelessWidget {
  final CoffeeItem item;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color _cardColor = Color(0xFF61466D);
  static const Color _pink = Color(0xFFFF9FD3);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF8C6B9A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33100A18),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x660C0710), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xDD21142F),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _pink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                if (item.apiId != null)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xEFA970D8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_done_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'LIVE API',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Row(
                    children: [
                      _ImageAction(
                        icon: Icons.edit_rounded,
                        tooltip: 'Edit product',
                        onPressed: onEdit,
                      ),
                      const SizedBox(width: 4),
                      _ImageAction(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Delete product',
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.currencyCode == 'USD' ? '\$' : '₱'}'
                          '${item.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          style: const TextStyle(
                            color: _pink,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (item.apiId == null)
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            tooltip: 'Add to cart',
                            padding: EdgeInsets.zero,
                            onPressed: onAdd,
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Color(0xFF2C2035),
                              size: 20,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: _pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        )
                      else
                        const Tooltip(
                          message: 'External API item · not available to order',
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white54,
                            size: 19,
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
    if (item.image.isEmpty) return _imagePlaceholder();

    return item.image.startsWith('assets/')
        ? Image.asset(
            item.image,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _imagePlaceholder(),
          )
        : Image.network(
            item.image,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _imagePlaceholder(),
          );
  }

  Widget _imagePlaceholder() => Container(
    color: const Color(0xFFA970D8),
    alignment: Alignment.center,
    child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 36),
  );
}

class _ImageAction extends StatelessWidget {
  const _ImageAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xDD21142F),
        foregroundColor: Colors.white,
        fixedSize: const Size(34, 34),
      ),
      icon: Icon(icon, size: 16),
    );
  }
}
