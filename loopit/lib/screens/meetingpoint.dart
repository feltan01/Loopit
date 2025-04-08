import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MeetingPointPage extends StatefulWidget {
  const MeetingPointPage({Key? key}) : super(key: key);

  @override
  State<MeetingPointPage> createState() => _MeetingPointPageState();
}

class _MeetingPointPageState extends State<MeetingPointPage> {
  // Controller for the Google Map
  late GoogleMapController _mapController;
  
  // Initial camera position
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(-6.288433, 106.668209), // Coordinates for Bintaro area
    zoom: 15.5,
  );

  // Markers for the map
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    
    // Add the Fresh Market marker
    _markers.add(
      Marker(
        markerId: const MarkerId('fresh_market'),
        position: const LatLng(-6.288433, 106.668209),
        infoWindow: const InfoWindow(
          title: 'Fresh Market Emerald Bintaro',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    
    // Add additional markers for reference points
    _markers.add(
      Marker(
        markerId: const MarkerId('donat_bahagia'),
        position: const LatLng(-6.289433, 106.667709),
        infoWindow: const InfoWindow(
          title: 'Donat bahagia bintaro',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );
    
    _markers.add(
      Marker(
        markerId: const MarkerId('jual_putih'),
        position: const LatLng(-6.290033, 106.668909),
        infoWindow: const InfoWindow(
          title: 'JUAL PUTIH',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4E6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF4A6741),
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  const Text(
                    'Meeting Point',
                    style: TextStyle(
                      color: Color(0xFF4A6741),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Map Container
            Expanded(
              child: GoogleMap(
                initialCameraPosition: _initialPosition,
                markers: _markers,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4E6),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.search,
                      color: Color(0xFF4A6741),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Location',
                          hintStyle: TextStyle(
                            color: Color(0xFF4A6741),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Meeting Point Info
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meeting Point',
                    style: TextStyle(
                      color: Color(0xFF4A6741),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Location Info
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
                                color: Color(0xFF4A6741),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                ],
              ),
            ),
            
            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirm button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F4E6),
                  foregroundColor: const Color(0xFF4A6741),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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