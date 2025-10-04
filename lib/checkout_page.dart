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
    if (serviceType == "kurir") return 20000;
    if (serviceType == "darurat") return 50000;
    return 0;
  }

  String _getServiceName() {
    if (serviceType == "motor") return "Motor";
    if (serviceType == "mobil") return "Mobil";
    if (serviceType == "kurir") return "Kirim Barang";
    if (serviceType == "darurat") return "Layanan Darurat";
    return "Layanan";
  }

  @override
  Widget build(BuildContext context) {
    final tarif = _getTarif();
    final serviceName = _getServiceName();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          serviceType == null ? "Detail Lokasi" : "Checkout $serviceName",
        ),
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
            if (serviceType == "darurat")
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: const Text(
                  "Ini adalah layanan bantuan prioritas. "
                  "Petugas terdekat akan segera dihubungi untuk memberikan pertolongan.",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

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
                title: Text(
                  serviceType == "darurat"
                      ? "Lokasi Kejadian"
                      : "Lokasi Tujuan",
                ),
                subtitle: Text(
                  "Lat: ${selectedLocation.latitude.toStringAsFixed(5)}, "
                  "Lng: ${selectedLocation.longitude.toStringAsFixed(5)}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Estimasi tarif
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
                      content: Text(
                        serviceType == null
                            ? "Lokasi disimpan!"
                            : "Pesanan $serviceName diproses...",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: serviceType == "darurat"
                      ? Colors.red
                      : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  serviceType == "darurat"
                      ? "Konfirmasi Panggilan Darurat"
                      : (serviceType == null ? "OK" : "Pesan Sekarang"),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
