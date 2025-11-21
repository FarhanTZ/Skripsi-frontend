import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/presentation/widgets/recommendation_card.dart';

class FoodMenuSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const FoodMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 191, // Matching height with cards on the home screen
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return RecommendationCard(title: item['title'], price: item['price'], icon: item['icon'], color: item['color']);
            },
          ),
        ),
      ],
    );
  }
}