import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:intl/intl.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  final VoidCallback? onAddTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with GI Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    (food.photoUrl != null && food.photoUrl!.isNotEmpty)
                        ? food.photoUrl!
                        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                    headers: const {'ngrok-skip-browser-warning': 'true'},
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey.shade100,
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey.shade100,
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                    ),
                  ),
                ),
                // GI Badge
                if (food.glycemicIndex != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildGIBadge(food.glycemicIndex!),
                  ),
              ],
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.foodName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormatter.format(food.price),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      InkWell(
                        onTap: onAddTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.add_circle,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGIBadge(num gi) {
    Color color = Colors.green;
    String label = "Low GI";
    if (gi >= 70) {
      color = Colors.red;
      label = "High GI";
    } else if (gi >= 56) {
      color = Colors.orange;
      label = "Med GI";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
