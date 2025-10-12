import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/Users/presentation/pages/analytic_tab.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/Users/presentation/pages/home_tab.dart';
import 'package:glupulse/features/Users/presentation/pages/menu_tab.dart';
import 'package:glupulse/features/Users/presentation/pages/profile_tab.dart';
import 'package:glupulse/features/Food/presentation/pages/cart_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    AnalyticTab(),
    MenuTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Atur warna background Scaffold. Warna ini akan muncul di lengkungan NavBar.
      backgroundColor: const Color(0xFFF2F5F9),
      body: Container(
        // Menggunakan Stack untuk menempatkan Floating Action Button di atas konten
        child: Stack(
          children: [
            // Konten utama halaman (HomeTab, AnalyticTab, dll.)
            Container(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            // Tombol keranjang belanja global
            Positioned(
              bottom: 30.0, // Menurunkan posisi lebih jauh agar pas di atas lengkungan NavBar
              right: 24.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary, // Warna biru dari tema
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: SvgPicture.asset('assets/images/shopping_cart.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 28, height: 28),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 75.0,
        items: [
          _buildNavItem(unselectedAsset: 'assets/images/Home.svg', selectedAsset: 'assets/images/Home_On.svg', index: 0, label: 'Home'),
          _buildNavItem(unselectedAsset: 'assets/images/Analytic.svg', selectedAsset: 'assets/images/analytic_On.svg', index: 1, label: 'Analytic'),
          _buildNavItem(unselectedAsset: 'assets/images/Menu.svg', selectedAsset: 'assets/images/Menu_On.svg', index: 2, label: 'Menu'),
          _buildNavItem(unselectedAsset: 'assets/images/Profile.svg', selectedAsset: 'assets/images/Profile_On.svg', index: 3, label: 'Profile'),
        ],
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: AppTheme.inputLabelColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildNavItem({required String unselectedAsset, required String selectedAsset, required int index, required String label}) {
    final bool isSelected = _selectedIndex == index;
    final String assetName = isSelected ? selectedAsset : unselectedAsset;
    final Color itemColor = Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tambahkan SizedBox untuk mendorong ikon ke bawah saat tidak dipilih
        if (!isSelected)
          const SizedBox(height: 8),

        SvgPicture.asset(
          assetName,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            itemColor,
            BlendMode.srcIn,
          ),
        ),
        // Hanya tampilkan teks jika item tidak sedang dipilih
        if (!isSelected) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: itemColor, fontSize: 10),
          ),
        ],
      ],
    );
  }
}