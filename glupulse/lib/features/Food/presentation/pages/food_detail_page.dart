import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_cubit.dart';
import 'package:glupulse/features/seller/presentation/pages/seller_profile_page.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;

  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CartCubit>()),
        BlocProvider(create: (_) => sl<SellerCubit>()),
      ],
      child: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartActionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Item berhasil ditambahkan ke keranjang!')),
              );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Gagal: ${state.message}')),
              );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Parallax Image Header
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    stretch: true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                      background: Image.network(
                        (widget.food.photoUrl != null && widget.food.photoUrl!.isNotEmpty)
                            ? widget.food.photoUrl!
                            : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                        headers: const {'ngrok-skip-browser-warning': 'true'},
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.food.foodName,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Text(
                                currencyFormatter.format(widget.food.price),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Rating Row
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                              const SizedBox(width: 4),
                              const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 4),
                              Text('(120 reviews)', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Category Badge (Moved below rating to prevent overflow)
                          if (widget.food.foodCategory != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.food.foodCategory!,
                                style: TextStyle(
                                  color: Colors.blue.shade700, 
                                  fontSize: 13, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 24),
                          _buildSellerInfo(),
                          const Divider(height: 48),
                          
                          _buildNutritionSection(),
                          const SizedBox(height: 24),
                          if (widget.food.glycemicIndex != null || widget.food.glycemicLoad != null)
                            _buildGlycemicInfo(),
                          
                          const Divider(height: 48),
                          
                          const Text(
                            'Description',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.food.description,
                            style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.6),
                          ),
                          
                          const SizedBox(height: 120), // Bottom padding for fixed buttons
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Fixed Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            IconButton(onPressed: _decrementQuantity, icon: const Icon(Icons.remove, size: 20)),
                            Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(onPressed: _incrementQuantity, icon: const Icon(Icons.add, size: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Add to Cart / Checkout
                      Expanded(
                        child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            final isLoading = state is CartLoadingAction;
                            return ElevatedButton(
                              onPressed: isLoading ? null : () {
                                context.read<CartCubit>().addItemToCart(widget.food.foodId, _quantity);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            );
                          },
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
    );
  }

  Widget _buildSellerInfo() {
    return InkWell(
      onTap: () {
        if (widget.food.sellerId != 'recommendation') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SellerProfilePage(
              sellerId: widget.food.sellerId,
              initialStoreName: widget.food.storeName,
            ),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.food.sellerId == 'recommendation' ? Icons.recommend : Icons.store,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.sellerId == 'recommendation' ? 'Recommended By AI' : 'Sold By',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    (widget.food.storeName != null && widget.food.storeName!.isNotEmpty) 
                        ? widget.food.storeName! 
                        : widget.food.sellerId,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.food.sellerId != 'recommendation')
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Facts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNutritionItem('Calories', '${widget.food.calories?.toInt() ?? '0'}', 'kcal', Colors.orange),
            _buildNutritionItem('Protein', '${widget.food.proteinGrams ?? '0'}', 'g', Colors.blue),
            _buildNutritionItem('Carbs', '${widget.food.carbsGrams ?? '0'}', 'g', Colors.green),
            _buildNutritionItem('Fat', '${widget.food.fatGrams ?? '0'}', 'g', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        Text(unit, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildGlycemicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (widget.food.glycemicIndex != null) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Glycemic Index', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${widget.food.glycemicIndex}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      _getGIBadge(widget.food.glycemicIndex!),
                    ],
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            const SizedBox(width: 16),
          ],
          if (widget.food.glycemicLoad != null) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Glycemic Load', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.food.glycemicLoad}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _getGIBadge(num gi) {
    Color color = Colors.green;
    String label = "LOW";
    if (gi >= 70) {
      color = Colors.red;
      label = "HIGH";
    } else if (gi >= 56) {
      color = Colors.orange;
      label = "MED";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
