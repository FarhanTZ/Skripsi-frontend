import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/Food/presentation/widgets/food_card.dart';

class AllMenuPage extends StatefulWidget {
  final String title;
  final List<dynamic> foods; // Using dynamic to match the type in MenuTab, but conceptually List<Food>

  const AllMenuPage({
    Key? key,
    required this.title,
    required this.foods,
  }) : super(key: key);

  @override
  State<AllMenuPage> createState() => _AllMenuPageState();
}

class _AllMenuPageState extends State<AllMenuPage> {
  List<dynamic> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _filteredFoods = widget.foods;
    _searchController.addListener(_filterFoods);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoods);
    _searchController.dispose();
    super.dispose();
  }

  // Get unique categories from the food list
  List<String> get _categories {
    final categories = widget.foods
        .map((f) => (f as Food).foodCategory ?? 'Other')
        .toSet()
        .toList();
    categories.sort(); // Sort alphabetically
    return ['All', ...categories];
  }

  void _filterFoods() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredFoods = widget.foods.where((food) {
        final f = food as Food;
        final matchesSearch = f.foodName.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' || 
                              (f.foodCategory ?? 'Other') == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterFoods();
  }

  @override
  Widget build(BuildContext context) {
    // Determine grid columns based on screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;
    // Aspect ratio adjustment for FoodCard to fit grid nicely
    final double childAspectRatio = 0.75; 

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background color
      body: SafeArea(
        child: Column(
          children: [
            // --- Modern Header Section ---
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Back Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari makanan...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterFoods(); // Manually trigger filter update
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => _onCategorySelected(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // --- Total Items Count ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Showing ${_filteredFoods.length} items',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),

            // --- Grid View ---
            Expanded(
              child: _filteredFoods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            widget.foods.isEmpty 
                                ? 'No items available.' 
                                : 'No items match your search.',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: _filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = _filteredFoods[index];
                        return FoodCard(
                          food: food,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FoodDetailPage(food: food),
                            ));
                          },
                        );
                      },
                    ),
            ),
        ],
      ),
    ));
  }
}