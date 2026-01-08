import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:glupulse/features/Address/domain/entities/address.dart';

class AddressDetailPage extends StatefulWidget {
  final Address address;

  const AddressDetailPage({super.key, required this.address});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  late LatLng _center;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.address.latitude, widget.address.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    // Tambahkan marker setelah peta dibuat
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('address_location'),
          position: _center,
          infoWindow: InfoWindow(
            title: widget.address.label,
            snippet: widget.address.addressDetail,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar ditempatkan di dalam Stack agar bisa transparan di atas peta
      body: Stack(
        children: [
          // Google Map sebagai background
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers,
          ),
          // AppBar transparan
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Detail Lokasi',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Kartu informasi alamat di bagian bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.address.label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.address.addressDetail, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}