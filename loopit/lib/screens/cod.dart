import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loopit/screens/payment_complete.dart';
import 'report.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CashOnDeliveryPage extends StatefulWidget {
  const CashOnDeliveryPage({Key? key}) : super(key: key);

  @override
  State<CashOnDeliveryPage> createState() => _CashOnDeliveryPageState();
}

class _CashOnDeliveryPageState extends State<CashOnDeliveryPage> {
  // Google Map Controller
 final LatLng meetingPoint = LatLng(-6.288433, 106.668209);
  final LatLng userLocation = LatLng(-6.292033, 106.668909);

  // Initial camera position (Emerald Bintaro coordinates)
  static const LatLng _meetingPointLocation = LatLng(-6.288433, 106.668209);

String? pickedImageName;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        pickedImageName = pickedImage.name;
      });
    }
  }

Widget buildMapSection() {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.35,
    child: FlutterMap(
      options: MapOptions(
        center: meetingPoint,
        zoom: 15.5,
      ),
      children: [
          if (!kIsWeb)
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
            ),
          if (kIsWeb)
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40,
              height: 40,
              point: meetingPoint,
              child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
            ),
            Marker(
              width: 40,
              height: 40,
              point: userLocation,
              child: const Icon(Icons.person_pin_circle, color: Colors.green, size: 36),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [
                meetingPoint,
                LatLng(-6.288933, 106.670209),
                LatLng(-6.290033, 106.671209),
                LatLng(-6.291033, 106.670809),
                userLocation,
              ],
              strokeWidth: 5.0,
              color: Colors.green.withOpacity(0.7),
            ),
          ],
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1EA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF4A6741)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Cash On Delivery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),
            ),

            // Map Section (About 35% of screen height)
          buildMapSection(),
            // Meeting Point Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meeting Point Header
                      const Text(
                        'Meeting Point',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Meeting Point Details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF4A6741),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Fresh Market Emerald Bintaro',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pintu Selatan Blok PE / KA-01, RW.1, Parigi, Pondok Aren, South Tangerang City, Banten 15227',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Total Section
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Items total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Items total',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Rp 550.000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Service fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Service fee',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Rp 2.000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(thickness: 1),
                      const SizedBox(height: 12),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp 552.000',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Delivery Proof Section
                      const Text(
                        'Delivery proof',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Upload Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.grey,
                          ),
                          label: Text(
                            pickedImageName ?? 'Attach your delivery proof',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),


                      const SizedBox(height: 24),

                      // Report Section
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Products/Transaction trouble?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportProblemScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Report',
                              style: TextStyle(
                                color: Color(0xFF4A6741),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Complete Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OrderComplete(), // Redirect to chat_seller.dart
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF1EA),
                    foregroundColor: const Color(0xFF4A6741),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
