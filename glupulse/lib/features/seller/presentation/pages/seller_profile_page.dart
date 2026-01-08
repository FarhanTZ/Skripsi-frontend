import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/Food/presentation/widgets/add_to_cart_bottom_sheet.dart';
import 'package:glupulse/features/Food/presentation/widgets/food_card.dart';
import 'package:glupulse/features/seller/domain/entities/seller.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_cubit.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_state.dart';
import 'package:glupulse/injection_container.dart';

class SellerProfilePage extends StatelessWidget {
  final String sellerId;
  final String? initialStoreName;

  const SellerProfilePage({super.key, required this.sellerId, this.initialStoreName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SellerCubit>()..fetchSeller(sellerId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<SellerCubit, SellerState>(
          builder: (context, sellerState) {
            if (sellerState is SellerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (sellerState is SellerError) {
              return _buildErrorView(context);
            } else if (sellerState is SellerLoaded) {
              return BlocBuilder<FoodCubit, FoodState>(
                builder: (context, foodState) {
                  return _buildSellerContent(context, sellerState.seller, foodState);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSellerContent(BuildContext context, Seller seller, FoodState foodState) {
    List<Widget> slivers = [];

    // 1. App Bar
    slivers.add(_buildSliverAppBar(context, seller));

    // 2. Info
    slivers.add(SliverToBoxAdapter(child: _buildSellerInfo(context, seller)));

    // 3. Menu Content
    if (foodState is FoodLoaded) {
      final sellerFoods = foodState.foods.where((f) => f.sellerId == seller.sellerId).toList();

      if (sellerFoods.isEmpty) {
        slivers.add(
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: Text("No menu items available.")),
            ),
          ),
        );
      } else {
        // Group items by category
        final groupedFoods = <String, List<Food>>{};
        for (var food in sellerFoods) {
          final category = food.foodCategory ?? 'Other';
          if (!groupedFoods.containsKey(category)) {
            groupedFoods[category] = [];
          }
          groupedFoods[category]!.add(food);
        }

        groupedFoods.forEach((category, foods) {
          // Category Header
          slivers.add(
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4, 
                      height: 24, 
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "${foods.length}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          // Grid for this category
          slivers.add(
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FoodCard(
                      food: foods[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FoodDetailPage(food: foods[index]),
                        ));
                      },
                      onAddTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddToCartBottomSheet(food: foods[index]),
                        );
                      },
                    );
                  },
                  childCount: foods.length,
                ),
              ),
            ),
          );
        });
      }
    } else if (foodState is FoodLoading) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 32)));

    return CustomScrollView(slivers: slivers);
  }

  Widget _buildSliverAppBar(BuildContext context, Seller seller) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            seller.bannerUrl != null
                ? Image.network(
                    seller.bannerUrl!,
                    fit: BoxFit.cover,
                    headers: const {'ngrok-skip-browser-warning': 'true'},
                    errorBuilder: (_, __, ___) => Image.asset('assets/images/seller.jpg', fit: BoxFit.cover),
                  )
                : Image.asset('assets/images/seller.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInfo(BuildContext context, Seller seller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header Row with Logo and Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                      image: DecorationImage(
                        image: (seller.logoUrl != null ? NetworkImage(seller.logoUrl!) : const AssetImage('assets/images/seller.jpg')) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          seller.storeName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: seller.isOpen ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: seller.isOpen ? Colors.green.shade200 : Colors.red.shade200),
                          ),
                          child: Text(
                            seller.isOpen ? 'Open Now' : 'Closed',
                            style: TextStyle(
                              color: seller.isOpen ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              if (seller.storeDescription != null && seller.storeDescription!.isNotEmpty)
                 Text(
                    seller.storeDescription!,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                 ),
              const SizedBox(height: 20),
              // Info Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildInfoChip(Icons.star_rounded, '${seller.averageRating.toStringAsFixed(1)}', Colors.amber),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.location_on, seller.city ?? 'Unknown', Colors.blue),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.restaurant, seller.cuisineType.isNotEmpty ? seller.cuisineType.first : 'Food', Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Divider(color: Colors.grey.shade100, thickness: 8),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(initialStoreName ?? 'Seller Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Failed to load seller information."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Go Back"),
            )
          ],
        ),
      ),
    );
  }
}
