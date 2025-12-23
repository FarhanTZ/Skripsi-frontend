import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
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
        appBar: AppBar(
          title: Text(initialStoreName ?? 'Store Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seller Info Section
              BlocBuilder<SellerCubit, SellerState>(
                builder: (context, state) {
                  if (state is SellerLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is SellerError) {
                    return _buildFallbackProfile(context);
                  } else if (state is SellerLoaded) {
                    return _buildSellerProfile(context, state.seller);
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              
              // Food List Section
              BlocBuilder<FoodCubit, FoodState>(
                builder: (context, state) {
                  if (state is FoodLoaded) {
                    final sellerFoods = state.foods.where((food) => food.sellerId == sellerId).toList();
                    
                    if (sellerFoods.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No items available from this seller.',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: sellerFoods.length,
                      itemBuilder: (context, index) {
                        return FoodCard(
                          food: sellerFoods[index],
                          onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FoodDetailPage(food: sellerFoods[index]),
                            ));
                          },
                        );
                      },
                    );
                  } else if (state is FoodLoading) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackProfile(BuildContext context) {
    if (initialStoreName != null && initialStoreName!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: const Icon(Icons.store, size: 80, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(initialStoreName!, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Seller details could not be loaded.', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      );
    }
    
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, color: Colors.grey, size: 40),
            const SizedBox(height: 8),
            Text('Seller Info Unavailable', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerProfile(BuildContext context, Seller seller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: seller.bannerUrl != null
              ? Image.network(
                  seller.bannerUrl!,
                  fit: BoxFit.cover,
                  headers: const {'ngrok-skip-browser-warning': 'true'},
                  errorBuilder: (_, __, ___) => const Icon(Icons.storefront, size: 80, color: Colors.grey),
                )
              : const Icon(Icons.storefront, size: 80, color: Colors.grey),
        ),
        // Store Info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: seller.logoUrl != null ? NetworkImage(seller.logoUrl!) : null,
                    child: seller.logoUrl == null ? const Icon(Icons.store, size: 40, color: Colors.grey) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(seller.storeName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          seller.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: seller.isOpen ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Description
              Text(
                seller.storeDescription ?? 'No description available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(height: 32),
              // Details
              _buildInfoRow(Icons.location_on_outlined, '${seller.addressLine1}, ${seller.city}'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone_outlined, seller.storePhoneNumber ?? 'No phone number'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.restaurant_menu_outlined, 'Cuisine: ${seller.cuisineType.join(', ')}'),
              const SizedBox(height: 12),
               _buildInfoRow(Icons.star_outline, '${seller.averageRating.toStringAsFixed(1)} (${seller.reviewCount} reviews)'),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
