import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'checkout_page.dart';

class SearchMapPage extends StatefulWidget {
  final String? serviceType;

  const SearchMapPage({super.key, this.serviceType});

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  late MapController _mapController;
  LatLng currentLocation = LatLng(-6.200000, 106.816666);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _confirmLocation() async {
    final selectedLocation = _mapController.camera.center;

    if (widget.serviceType == null) {
      final chosenService = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pilih Layanan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.two_wheeler, color: Colors.blue),
                  title: const Text("Motor"),
                  onTap: () => Navigator.pop(context, "motor"),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.directions_car,
                    color: Colors.green,
                  ),
                  title: const Text("Mobil"),
                  onTap: () => Navigator.pop(context, "mobil"),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.local_shipping,
                    color: Colors.brown,
                  ),
                  title: const Text("Kirim Barang"),
                  onTap: () => Navigator.pop(context, "kurir"),
                ),
                ListTile(
                  leading: const Icon(Icons.emergency, color: Colors.red),
                  title: const Text("Layanan Darurat"),
                  onTap: () => Navigator.pop(context, "darurat"),
                ),
              ],
            ),
          );
        },
      );

      if (chosenService != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(
              selectedLocation: selectedLocation,
              serviceType: chosenService,
            ),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            selectedLocation: selectedLocation,
            serviceType: widget.serviceType,
          ),
        ),
      );
    }
  }

  Widget _buildEmergencyInfo() {
    if (widget.serviceType == "darurat") {
      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade400),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red.shade700),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Anda berada dalam mode Layanan Darurat. "
                  "Pastikan pin merah berada tepat di lokasi kejadian Anda "
                  "untuk mendapatkan bantuan tercepat.",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceType == null
              ? "Pilih Lokasi"
              : widget.serviceType == "darurat"
              ? "Konfirmasi Lokasi Darurat"
              : "Pilih Lokasi ${widget.serviceType}",
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocation,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=API_KEY",
                userAgentPackageName: 'com.jalaninaja.app',
              ),
            ],
          ),
          const Center(
            child: Icon(Icons.location_on, color: Colors.red, size: 50),
          ),

          _buildEmergencyInfo(),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: widget.serviceType == "darurat"
                    ? Colors.red
                    : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.serviceType == "darurat"
                    ? "Panggil Bantuan Sekarang"
                    : widget.serviceType == null
                    ? "Konfirmasi Lokasi"
                    : "Lanjut ke Checkout",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
