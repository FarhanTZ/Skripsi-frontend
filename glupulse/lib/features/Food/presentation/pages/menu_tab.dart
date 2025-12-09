import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_cubit.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';
import 'package:glupulse/features/Address/presentation/pages/address_list_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/Food/presentation/widgets/food_card.dart';
import 'package:glupulse/features/Food/presentation/pages/all_menu_page.dart'; // Import AllMenuPage
import 'package:glupulse/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:glupulse/injection_container.dart';

import 'order_history_page.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({Key? key}) : super(key: key);

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  // Controller untuk PageView promo
  final _promoPageController = PageController();

  // Data untuk kategori
  final List<String> categories = const [
    'Main',
    'Salads',
    'Sides',
    'Desert',
    'Drink'
  ];

  // State untuk alamat yang sedang aktif
  AddressModel _currentAddress = const AddressModel(
    addressId: '',
    userId: '',
    addressLabel: 'Loading...',
    addressLine1: 'Mencari lokasi...',
    isDefault: false,
    isActive: false,
  );
  bool _isFetchingAddress = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndAddress();
    context.read<FoodCubit>().fetchFoods();
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller untuk menghindari memory leak
    _promoPageController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocationAndAddress() async {
    setState(() {
      _isFetchingAddress = true;
    });

    try {
      // 1. Cek izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Pengguna menolak izin
          setState(() {
            _currentAddress = _currentAddress.copyWith(
              addressLabel: 'Lokasi tidak diizinkan',
              addressLine1: 'Ketuk untuk mengubah',
            );
            _isFetchingAddress = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Izin ditolak permanen
        setState(() {
          _currentAddress = _currentAddress.copyWith(
            addressLabel: 'Izin lokasi ditolak',
            addressLine1: 'Buka pengaturan untuk mengizinkan',
          );
          _isFetchingAddress = false;
        });
        return;
      }

      // 2. Dapatkan lokasi saat ini
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // 3. Ubah koordinat menjadi alamat (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Membangun string alamat dengan lebih aman untuk menghindari null
        String address = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
          if (place.locality != null && place.locality!.isNotEmpty) place.locality,
          if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ].where((part) => part != null).join(', ');

        setState(() {
          _currentAddress = _currentAddress.copyWith(
            addressLabel: 'Lokasi Saat Ini',
            addressLine1: address,
            addressLatitude: position.latitude,
            addressLongitude: position.longitude,
          );
        });
      }
    } catch (e) {
      // Tangani error
      setState(() => _currentAddress = _currentAddress.copyWith(
            addressId: _currentAddress.addressId,
            userId: _currentAddress.userId,
            addressLabel: 'Error',
            addressLine1: 'Gagal mendapatkan lokasi',
      ));
    } finally {
      if (mounted) setState(() => _isFetchingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using Stack to overlap widgets
    return SingleChildScrollView(
        child:
        Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 24), // Padding diubah
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final AddressModel? selectedAddress = await Navigator.of(context).push(
                              MaterialPageRoute(
                                // Bungkus dengan MultiBlocProvider untuk menyediakan ProfileCubit dan AddressCubit
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(create: (_) => sl<ProfileCubit>()),
                                    BlocProvider(create: (_) => sl<AddressCubit>()),
                                  ],
                                  child: AddressListPage(
                                      addresses: const [], currentSelectedAddress: _currentAddress),
                                ),
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
                    _isFetchingAddress
                        ? const Row(
                            children: [
                              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)),
                              SizedBox(width: 12),
                              Text('Mencari lokasi...', style: TextStyle(color: Colors.white70, fontSize: 18)),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => AddressDetailPage(address: _currentAddress),
                              // ));
                            },
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(_currentAddress.addressLine1 ?? 'Alamat tidak tersedia',
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
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
            const SizedBox(height: 24),
            // --- Special Promo ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Special Promo',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- Kartu Promo dengan PageView ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent, // Warna dasar kartu
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      controller: _promoPageController,
                      children: [
                        _buildPromoPage(
                          title: 'Diskon 50%',
                          description: 'Untuk semua menu utama hari ini!',
                        ),
                        _buildPromoPage(
                          title: 'Beli 1 Gratis 1',
                          description: 'Untuk semua minuman sehat.',
                        ),
                        _buildPromoPage(
                          title: 'Gratis Ongkir',
                          description: 'Tanpa minimum pembelian.',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SmoothPageIndicator(
                        controller: _promoPageController,
                        count: 3, // Sesuaikan dengan jumlah halaman promo
                        effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, activeDotColor: Colors.white, dotColor: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
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
            
            // --- Food Menu from API ---
            BlocBuilder<FoodCubit, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FoodLoaded) {
                  // Pisahkan makanan dan minuman berdasarkan tags
                  final foods = state.foods.where((f) => f.tags?.contains('drink') == false).toList();
                  final drinks = state.foods.where((f) => f.tags?.contains('drink') == true).toList();

                  return Column(
                    children: [
                      _buildFoodSection(context, 'Recommendation Food', foods), // Pass full list
                      const SizedBox(height: 24),
                      _buildFoodSection(context, 'Food Menu', foods), // Pass full list
                      const SizedBox(height: 24),
                      _buildFoodSection(context, 'Drink Menu', drinks), // Pass full list
                    ],
                  );
                } else if (state is FoodError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink(); // Initial state
              },
            ),
            const SizedBox(height: 24), // Space below
          ],
        ),
    );
  }

  // Widget baru untuk membangun setiap seksi menu
  Widget _buildFoodSection(BuildContext context, String title, List<dynamic> fullItems) {
    // Only display first 5 items in the horizontal preview
    final previewItems = fullItems.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.primary
                )
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllMenuPage(
                      title: title, 
                      foods: fullItems
                    ),
                  ));
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (previewItems.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("No items available."),
          )
        else
          SizedBox(
            height: 180, // Sesuaikan tinggi sesuai kebutuhan FoodCard
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: previewItems.length,
              itemBuilder: (context, index) {
                final food = previewItems[index];
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
    );
  }

  // Helper widget untuk membuat ISI dari halaman promo di dalam PageView
  Widget _buildPromoPage({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}