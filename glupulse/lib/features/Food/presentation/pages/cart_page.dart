import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Food/domain/entities/cart_item.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/Food/presentation/pages/payment_order_page.dart';
import 'package:glupulse/features/Food/presentation/cubit/checkout_cubit.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  Set<String> _selectedItemIds = {}; // Local state for item selection
  
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  bool get _isAllSelected {
    if (_cartItems.isEmpty) return false;
    return _cartItems.length == _selectedItemIds.length;
  }

  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (_selectedItemIds.contains(item.cartItemId)) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedItemIds = _cartItems.map((item) => item.cartItemId).toSet();
      } else {
        _selectedItemIds.clear();
      }
    });
  }

  void _toggleItemSelection(String cartItemId) {
    setState(() {
      if (_selectedItemIds.contains(cartItemId)) {
        _selectedItemIds.remove(cartItemId);
      } else {
        _selectedItemIds.add(cartItemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartLoaded) {
            setState(() {
              _cartItems = List<CartItem>.from(state.cart.items);
              // Sync selection state: remove IDs that are no longer in the cart
              final currentIds = _cartItems.map((e) => e.cartItemId).toSet();
              _selectedItemIds = _selectedItemIds.intersection(currentIds);
              
              // If it's the first time loading, select everything by default
              if (_selectedItemIds.isEmpty && _cartItems.isNotEmpty) {
                _selectedItemIds = currentIds;
              }
            });
          } else if (state is CartError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CartLoading && _cartItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_cartItems.isEmpty && state is CartLoaded) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Select All Header
              if (_cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isAllSelected,
                        onChanged: _toggleSelectAll,
                        activeColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      const Text("Select All", style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text("${_selectedItemIds.length} items selected", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItemCard(_cartItems[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _cartItems.isNotEmpty ? _buildCheckoutBar() : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Your cart is empty", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text("Add some delicious food to get started!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    final isSelected = _selectedItemIds.contains(item.cartItemId);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleItemSelection(item.cartItemId),
              activeColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                (item.photoUrl != null && item.photoUrl!.isNotEmpty)
                    ? item.photoUrl!
                    : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                headers: const {'ngrok-skip-browser-warning': 'true'},
                errorBuilder: (_, __, ___) => Container(
                  width: 70, height: 70, color: Colors.grey.shade100,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.foodName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(item.price),
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () => _decrementQuantity(item)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      _buildQtyBtn(Icons.add, () => _incrementQuantity(item)),
                    ],
                  ),
                ],
              ),
            ),
            
            // Delete Action
            IconButton(
              onPressed: () => _confirmRemoveItem(context, item),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  void _incrementQuantity(CartItem item) {
    // Optimistic Update: Update UI immediately
    setState(() {
      final index = _cartItems.indexWhere((i) => i.cartItemId == item.cartItemId);
      if (index != -1) {
        _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
      }
    });
    
    context.read<CartCubit>().updateItemQuantity(item.foodId, item.quantity + 1);
  }

  void _decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      // Optimistic Update
      setState(() {
        final index = _cartItems.indexWhere((i) => i.cartItemId == item.cartItemId);
        if (index != -1) {
          _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
        }
      });
      context.read<CartCubit>().updateItemQuantity(item.foodId, item.quantity - 1);
    } else {
      _confirmRemoveItem(context, item);
    }
  }

  Future<void> _confirmRemoveItem(BuildContext context, CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to remove "${item.foodName}" from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if(!mounted) return;
      context.read<CartCubit>().removeItemFromCart(item.foodId);
    }
  }

  Widget _buildCheckoutBar() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payment", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
              Text(
                currencyFormatter.format(_totalPrice),
                style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectedItemIds.isEmpty ? null : () {
              final selectedItems = _cartItems.where((item) => _selectedItemIds.contains(item.cartItemId)).toList();
              
              final orderItems = selectedItems.map((item) {
                return {
                  'name': item.foodName,
                  'quantity': item.quantity,
                  'price': item.price,
                };
              }).toList();

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<CheckoutCubit>(),
                  child: PaymentOrderPage(
                    orderItems: orderItems,
                    totalPrice: _totalPrice,
                  ),
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}