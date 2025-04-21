import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String condition;
  final String imageUrl;

  const ListingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.condition,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 4),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F2E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(condition,
                      style: const TextStyle(
                          color: Color(0xFF4E6E39), fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
