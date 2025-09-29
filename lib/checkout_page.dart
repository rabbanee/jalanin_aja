import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CheckoutPage extends StatelessWidget {
  final LatLng selectedLocation;
  final String? serviceType;

  const CheckoutPage({
    super.key,
    required this.selectedLocation,
    this.serviceType,
  });

  int _getTarif() {
    if (serviceType == "motor") return 15000;
    if (serviceType == "mobil") return 35000;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final tarif = _getTarif();

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceType == null ? "Detail Lokasi" : "Checkout $serviceType"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Pemesanan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lokasi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text("Lokasi Tujuan"),
                subtitle: Text(
                  "Lat: ${selectedLocation.latitude.toStringAsFixed(5)}, "
                  "Lng: ${selectedLocation.longitude.toStringAsFixed(5)}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Estimasi tarif hanya jika motor/mobil
            if (serviceType != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.blue.shade50,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Estimasi Tarif",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Rp $tarif",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(serviceType == null
                          ? "Lokasi disimpan!"
                          : "Pesanan $serviceType diproses..."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  serviceType == null ? "OK" : "Pesan Sekarang",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
