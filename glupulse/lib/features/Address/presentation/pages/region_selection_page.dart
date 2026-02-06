import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// Model untuk data wilayah
class Region {
  final String id;
  final String name;

  Region({required this.id, required this.name});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RegionSelectionPage extends StatefulWidget {
  const RegionSelectionPage({super.key});

  @override
  State<RegionSelectionPage> createState() => _RegionSelectionPageState();
}
class _RegionSelectionPageState extends State<RegionSelectionPage> {
  int _currentStep = 0;
  List<Region> _provinces = [];
  List<Region> _cities = [];
  List<Region> _districts = [];

  Region? _selectedProvince;
  Region? _selectedCity;
  Region? _selectedDistrict;

  bool _isLoading = false;
  String _error = '';

  final TextEditingController _searchController = TextEditingController();
  List<Region> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProvinces() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final response = await http.get(Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _provinces = data.map((json) => Region.fromJson(json)).toList();
          _filteredList = _provinces;
        });
      } else {
        throw Exception('Gagal memuat provinsi');
      }
    } catch (e) {
      setState(() => _error = 'Gagal memuat data. Periksa koneksi internet Anda.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCities(String provinceId) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final response = await http.get(Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _cities = data.map((json) => Region.fromJson(json)).toList();
          _filteredList = _cities;
          _currentStep = 1;
        });
      } else {
        throw Exception('Gagal memuat kota/kabupaten');
      }
    } catch (e) {
      setState(() => _error = 'Gagal memuat data. Periksa koneksi internet Anda.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchDistricts(String cityId) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final response = await http.get(Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/districts/$cityId.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _districts = data.map((json) => Region.fromJson(json)).toList();
          _filteredList = _districts;
          _currentStep = 2;
        });
      } else {
        throw Exception('Gagal memuat kecamatan');
      }
    } catch (e) {
      setState(() => _error = 'Gagal memuat data. Periksa koneksi internet Anda.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    List<Region> sourceList;
    switch (_currentStep) {
      case 0:
        sourceList = _provinces;
        break;
      case 1:
        sourceList = _cities;
        break;
      case 2:
        sourceList = _districts;
        break;
      default:
        sourceList = [];
    }
    setState(() {
      _filteredList = sourceList.where((region) => region.name.toLowerCase().contains(query)).toList();
    });
  }

  void _onRegionSelected(Region region) {
    _searchController.clear();
    switch (_currentStep) {
      case 0:
        _selectedProvince = region;
        _fetchCities(region.id);
        break;
      case 1:
        _selectedCity = region;
        _fetchDistricts(region.id);
        break;
      case 2:
        _selectedDistrict = region;
        // Semua data sudah terpilih, kembali ke halaman sebelumnya
        final result = {
          'province': _selectedProvince!.name,
          'city': _selectedCity!.name,
          'district': _selectedDistrict!.name,
        };
        Navigator.of(context).pop(result);
        break;
    }
  }

  String _getTitle() {
    switch (_currentStep) {
      case 0:
        return 'Pilih Provinsi';
      case 1:
        return 'Pilih Kota/Kabupaten';
      case 2:
        return 'Pilih Kecamatan';
      default:
        return 'Pilih Wilayah';
    }
  }

  void _goBack() {
    _searchController.clear();
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        if (_currentStep == 0) {
          _filteredList = _provinces;
          _selectedCity = null;
          _selectedDistrict = null;
        } else if (_currentStep == 1) {
          _filteredList = _cities;
          _selectedDistrict = null;
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Menentukan posisi saat ini dan melakukan reverse geocoding.
  Future<void> _getCurrentLocationAndGoBack() async {
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

        // Ekstrak informasi yang relevan
        // Nama field bisa bervariasi, sesuaikan jika perlu
        String province = place.administrativeArea ?? '';
        String city = place.subAdministrativeArea ?? '';
        String district = place.locality ?? place.subLocality ?? '';
        String postalCode = place.postalCode ?? '';

        if (province.isEmpty || city.isEmpty || district.isEmpty) {
          throw Exception('Gagal mendapatkan detail alamat dari lokasi Anda.');
        }

        final result = {
          'postalCode': postalCode,
          'province': province.toUpperCase(), // API biasanya mengembalikan huruf besar
          'city': city.toUpperCase(),
          'district': district.toUpperCase(),
        };

        // Kembali ke halaman sebelumnya dengan hasil
        if (mounted) {
          Navigator.of(context).pop(result);
        }
      } else { 
        throw Exception('Tidak ada alamat yang ditemukan untuk lokasi saat ini.');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
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
            Expanded(
                child: _buildInfoWidget(
                    icon: Icons.error_outline, text: _error))
          else if (_filteredList.isEmpty)
            Expanded(
                child: _buildInfoWidget(
                    icon: Icons.search_off,
                    text: 'Wilayah tidak ditemukan.\nCoba kata kunci lain.'))
          else
            Expanded(
              child: _buildRegionList(),
            ),
        ],
      ),
    );
  }

  /// Widget untuk tombol "Gunakan Lokasi Saat Ini".
  Widget _buildCurrentLocationButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _getCurrentLocationAndGoBack,
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
      decoration: InputDecoration(
        hintText: 'Cari nama wilayah...',
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

  /// Widget untuk menampilkan daftar wilayah.
  Widget _buildRegionList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) {
        final item = _filteredList[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: ListTile(
            title: Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.location_on_outlined, color: Colors.grey),
            onTap: () => _onRegionSelected(item),
          ),
        );
      },
    );
  }

  /// Widget untuk menampilkan informasi seperti error atau data kosong.
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