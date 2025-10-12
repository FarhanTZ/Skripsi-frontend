import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/Address/presentation/pages/address_list_page.dart';

import '../../../Food/presentation/pages/order_history_page.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  // Data untuk kategori
  final List<String> categories = const [
    'Main',
    'Salads',
    'Sides',
    'Desert',
    'Drink'
  ];

  // State untuk alamat yang sedang aktif
  Map<String, String> _currentAddress = {
    'label': 'Home',
    'address': 'Jl. Telekomunikasi No. 1, Bandung',
  };

  @override
  Widget build(BuildContext context) {
    // Using Stack to overlap widgets
    return SingleChildScrollView(
        child: Stack(
      alignment: Alignment.topCenter, // To center the promo container horizontally
      children: [
        // Main background widget
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 320, // Mengurangi tinggi container biru
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40), // Mengatur lengkungan di bawah
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 60, left: 24, right: 24), // Padding from top and sides
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selectedAddress = await Navigator.of(context)
                                .push<Map<String, String>>(
                              MaterialPageRoute(
                                builder: (context) => AddressListPage(
                                    currentAddress: _currentAddress),
                              ),
                            );
                            if (selectedAddress != null) {
                              setState(() {
                                _currentAddress = selectedAddress;
                              });
                            }
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  color: Colors.white70, // Grayish color (transparent white)
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.receipt_long, // Mengganti ikon menjadi seperti kertas/nota
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentAddress['address']!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for menus, recipes, or articles...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Space to prevent the category list from being overlapped by the promo card
            SizedBox(height: (187 / 2) + 20),
            // Menu Categories
            SizedBox(
              height: 32, // Reducing the height of the category list area
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
                height: 20), // Additional space below the category list
            // --- Recommendation Food ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommendation Food',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 191, // Matching height with cards on the home screen
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildRecommendationCard(
                    context: context,
                    title: 'Oatmeal',
                    description: 'Good for breakfast',
                    icon: Icons.breakfast_dining_outlined,
                    color: Colors.brown,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Salmon',
                    description: 'Rich in Omega-3',
                    icon: Icons.set_meal_outlined,
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Avocado',
                    description: 'Healthy fats',
                    icon: Icons.spa_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // --- Food Menu ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Food Menu',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 191, // Matching height with cards on the home screen
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildRecommendationCard(
                    context: context,
                    title: 'Oatmeal',
                    description: 'Good for breakfast',
                    icon: Icons.breakfast_dining_outlined,
                    color: Colors.brown,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Salmon',
                    description: 'Rich in Omega-3',
                    icon: Icons.set_meal_outlined,
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Avocado',
                    description: 'Healthy fats',
                    icon: Icons.spa_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Drink Menu ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Drink Menu',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 191, // Matching height with cards on the home screen
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildRecommendationCard(
                    context: context,
                    title: 'Water',
                    description: 'Stay hydrated',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Orange Juice',
                    description: 'Rich in Vitamin C',
                    icon: Icons.local_drink,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildRecommendationCard(
                    context: context,
                    title: 'Green Smoothie',
                    description: 'Full of nutrients',
                    icon: Icons.blender,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Space below
          ],
        ),

        // Promo Container stacked on top
        Positioned(
          // Position from top: (blue container height) - (half of promo container height)
          top: 320 - (187 / 2), // Adjusting promo container position
          child: Container(
            width: 383,
            height: 187,
            decoration: BoxDecoration(
              color: AppTheme.inputLabelColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            // Using Align to place the label container in the corner
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    // This is the white container that wraps the text
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // Creating a shape like a label/tag
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Promo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.inputLabelColor),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: const Color(0xFFBC9A9A),
                          padding: const EdgeInsets.only(
                              left: 12, right: 60, top: 0, bottom: 0),
                          child: const Text(
                            'Buy One get',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Adding vertical space
                        Container(
                          color: const Color(0xFFBC9A9A),
                          padding: const EdgeInsets.only(
                              left: 12, right: 60, top: 0, bottom: 0),
                          child: const Text(
                            'One Free',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  // Helper widget to create recommendation cards (copied from home_tab.dart)
  Widget _buildRecommendationCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 160, // Matching width with other cards
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Ensures InkWell ripple effect is clipped
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoodDetailPage(foodName: title),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}