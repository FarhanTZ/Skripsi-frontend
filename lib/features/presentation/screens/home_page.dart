import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/presentation/screens/User/analytic_tab.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/presentation/screens/User/home_tab.dart';
import 'package:glupulse/features/presentation/screens/User/menu_tab.dart';
import 'package:glupulse/features/presentation/screens/User/profile_tab.dart';
import 'package:glupulse/features/presentation/screens/Food/cart_page.dart';


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
      // Agar efek lengkung CurvedNavigationBar terlihat, Scaffold dibuat transparan
      // dan body dibungkus Container dengan warna.
      backgroundColor: Colors.transparent,
      body: Container(
        // Menggunakan Stack untuk menempatkan Floating Action Button di atas konten
        child: Stack(
          children: [
            // Konten utama halaman (HomeTab, AnalyticTab, dll.)
            Container(
              color: const Color(0xFFF2F5F9),
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
                  child: SvgPicture.asset('images/shopping_cart.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 28, height: 28),
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
          _buildNavItem(unselectedAsset: 'images/Home.svg', selectedAsset: 'images/Home_on.svg', index: 0, label: 'Home'),
          _buildNavItem(unselectedAsset: 'images/Analytic.svg', selectedAsset: 'images/Analytic_on.svg', index: 1, label: 'Analytic'),
          _buildNavItem(unselectedAsset: 'images/Menu.svg', selectedAsset: 'images/Menu_on.svg', index: 2, label: 'Menu'),
          _buildNavItem(unselectedAsset: 'images/Profile.svg', selectedAsset: 'images/Profile_on.svg', index: 3, label: 'Profile'),
        ], // Ganti dengan path ikon SVG Anda
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