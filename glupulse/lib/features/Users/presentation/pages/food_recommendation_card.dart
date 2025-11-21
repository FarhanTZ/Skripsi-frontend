import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:intl/intl.dart';

class FoodRecommendationCard extends StatelessWidget {
  final Food food;

  const FoodRecommendationCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return SizedBox(
      width: 170, // Menyamakan lebar dengan card lain
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigasi ke halaman detail dengan data food asli
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoodDetailPage(food: food),
            ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Gambar Makanan
              SizedBox(
                height: 100,
                width: double.infinity,
                child: (food.photoUrl != null && food.photoUrl!.isNotEmpty)
                    ? Image.network(
                        food.photoUrl!,
                        headers: const {'ngrok-skip-browser-warning': 'true'},
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                      ),
              ),
              // Bagian Teks (Judul dan Harga)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        food.foodName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(currencyFormatter.format(food.price), style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
