import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class StreetSearchResult {
  final String displayName;
  final String street;
  final String city;
  final String postcode;

  StreetSearchResult({
    required this.displayName,
    required this.street,
    required this.city,
    required this.postcode,
  });

  factory StreetSearchResult.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    return StreetSearchResult(
      displayName: json['display_name'] ?? 'Alamat tidak tersedia',
      street: address['road'] ?? '',
      city: address['city'] ?? address['town'] ?? address['county'] ?? '',
      postcode: address['postcode'] ?? '',
    );
  }
}

class StreetSelectionPage extends StatefulWidget {
  const StreetSelectionPage({super.key});

  @override
  State<StreetSelectionPage> createState() => _StreetSelectionPageState();
}

class _StreetSelectionPageState extends State<StreetSelectionPage> {
  final _searchController = TextEditingController();
  List<StreetSearchResult> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 750), () {
      if (_searchController.text.length > 3) {
        _searchAddress(_searchController.text);
      }
    });
  }

  Future<void> _searchAddress(String query) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&countrycodes=id&addressdetails=1');

    try {
      // PERBAIKAN: Tambahkan header 'User-Agent' yang unik untuk aplikasi Anda.
      final response = await http.get(url, headers: {
        'Accept-Language': 'id',
        'User-Agent': 'com.example.glupulse', // Ganti dengan nama aplikasi Anda
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults =
              data.map((json) => StreetSearchResult.fromJson(json)).toList();
          if (_searchResults.isEmpty) {
            _error = 'Alamat tidak ditemukan. Coba kata kunci lain.';
          }
        });
      } else {
        // Memberikan pesan error yang lebih spesifik berdasarkan status code
        if (response.statusCode == 429) {
          throw Exception('Terlalu banyak percobaan. Silakan coba lagi nanti.');
        } else if (response.statusCode == 403) {
          throw Exception('Akses ditolak oleh server. Pastikan User-Agent valid.');
        } else {
          throw Exception('Gagal mencari alamat. Kode: ${response.statusCode}');
        }
      }
    } catch (e) {
      setState(() {
        // Menampilkan pesan dari exception jika ada, atau pesan default
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Menentukan posisi saat ini dan melakukan reverse geocoding untuk mendapatkan alamat jalan.
  Future<void> _getCurrentLocationAndSelect() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Layanan lokasi dinonaktifkan.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Lakukan reverse geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Gabungkan informasi jalan, nomor, dan area sekitar
        String streetAddress =
            (place.street ?? '').trim();

        if (streetAddress.isEmpty) {
          throw Exception('Gagal mendapatkan nama jalan dari lokasi Anda.');
        }

        // Kembali ke halaman sebelumnya dengan hasil alamat jalan
        if (mounted) {
          Navigator.of(context).pop(streetAddress);
        }
      } else {
        throw Exception('Tidak ada alamat yang ditemukan untuk lokasi saat ini.');
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      // Pastikan loading berhenti meskipun navigator sudah pop
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Cari Alamat Jalan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: _buildCurrentLocationButton(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildSearchBar(),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error.isNotEmpty)
            Expanded(child: _buildInfoWidget(icon: Icons.error_outline, text: _error))
          else if (_searchController.text.isEmpty)
            Expanded(
              child: _buildInfoWidget(
                icon: Icons.edit_location_alt_outlined,
                text: 'Mulai ketik untuk mencari alamat jalan, gedung, atau area.',
              ),
            )
          else if (_searchResults.isEmpty)
            Expanded(
              child: _buildInfoWidget(
                icon: Icons.search_off,
                text: 'Alamat tidak ditemukan.\nCoba kata kunci lain.',
              ),
            )
          else
            Expanded(
              child: _buildResultsList(),
            ),
        ],
      ),
    );
  }

  /// Widget untuk tombol "Gunakan Lokasi Saat Ini".
  Widget _buildCurrentLocationButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _getCurrentLocationAndSelect,
      icon: const Icon(Icons.my_location),
      label: const Text('Gunakan Lokasi Saat Ini'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Widget untuk search bar.
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Ketik nama jalan, gedung, atau area...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan daftar hasil pencarian alamat.
  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: ListTile(
            title: Text(result.displayName,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.location_on_outlined, color: Colors.grey),
            onTap: () => Navigator.of(context).pop(result.displayName),
          ),
        );
      },
    );
  }

  /// Widget untuk menampilkan informasi seperti error, data kosong, atau prompt awal.
  Widget _buildInfoWidget({required IconData icon, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}