import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final bool showStock;
  final bool isOutOfStock;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.showStock = false,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image/Emoji
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        product.image,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Product Category
                Text(
                  product.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),

                if (showStock) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product.stockQuantity}',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.stockQuantity > 10
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],

                const Spacer(),

                // Price and Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        if (product.stockQuantity < 5 && product.stockQuantity > 0)
                          Text(
                            'Low stock',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange[600],
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: isOutOfStock ? null : onAddToCart,
                      icon: Icon(
                        isOutOfStock ? Icons.block : Icons.add_circle,
                        color: isOutOfStock
                            ? Colors.grey
                            : const Color(0xFF2563EB),
                      ),
                      iconSize: 24,
                      tooltip: isOutOfStock ? 'Out of stock' : 'Add to cart',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Out of Stock Overlay
          if (isOutOfStock)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'OUT OF STOCK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}