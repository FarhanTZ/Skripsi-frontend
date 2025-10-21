import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? price;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170, // Matching width with other cards
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        clipBehavior: Clip.antiAlias, // Ensures InkWell ripple effect is clipped
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoodDetailPage(foodName: title),
            ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Gambar/Ikon
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 40),
                  ),
                ),
              ),
              // Bagian Teks (Judul dan Harga/Deskripsi)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    if (price != null)
                      Text(price!, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}