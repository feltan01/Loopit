import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loopit/screens/ordetail_address.dart';

class MeetingPointPage extends StatefulWidget {
  const MeetingPointPage({Key? key}) : super(key: key);

  @override
  State<MeetingPointPage> createState() => _MeetingPointPageState();
}

class _MeetingPointPageState extends State<MeetingPointPage> {
  final MapController _mapController = MapController();

  LatLng _selectedLocation = const LatLng(-6.288433, 106.668209);
  String _selectedLocationName = 'Fresh Market Emerald Bintaro';
  String _selectedLocationAddress =
      'Pintu Selatan Blok PE / KA-01, RW.1, Parigi, Pondok Aren, South Tangerang City, Banten 15227';

  final List<Map<String, dynamic>> _predefinedLocations = [
    {
      'id': 'fresh_market',
      'position': const LatLng(-6.288433, 106.668209),
      'title': 'Fresh Market Emerald Bintaro',
      'address':
          'Pintu Selatan Blok PE / KA-01, RW.1, Parigi, Pondok Aren, South Tangerang City, Banten 15227',
      'color': Colors.red,
    },
    {
      'id': 'donat_bahagia',
      'position': const LatLng(-6.289433, 106.667709),
      'title': 'Donat bahagia bintaro',
      'address':
          'Jl. Emerald Boulevard, Parigi, Pondok Aren, South Tangerang City, Banten',
      'color': Colors.orange,
    },
    {
      'id': 'jual_putih',
      'position': const LatLng(-6.290033, 106.668909),
      'title': 'JUAL PUTIH',
      'address':
          'Jl. CBD Emerald Blok CE/A, Parigi, Pondok Aren, South Tangerang City, Banten',
      'color': Colors.blue,
    },
  ];

  List<Marker> _buildMarkers() {
    List<Marker> markers = _predefinedLocations.map((location) {
      return Marker(
        width: 40,
        height: 40,
        point: location['position'],
        child: GestureDetector(
          onTap: () {
            _selectLocation(
              location['position'],
              location['title'],
              location['address'],
            );
          },
          child: Icon(
            Icons.location_pin,
            color: location['color'],
            size: 36,
          ),
        ),
      );
    }).toList();

    // Add custom marker if it's not a predefined location
    if (!_predefinedLocations
        .any((loc) => loc['position'] == _selectedLocation)) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: _selectedLocation,
          child: const Icon(
            Icons.location_pin,
            color: Colors.green,
            size: 36,
          ),
        ),
      );
    }

    return markers;
  }

  void _selectLocation(LatLng position, String name, String address) {
    setState(() {
      _selectedLocation = position;
      _selectedLocationName = name;
      _selectedLocationAddress = address;
    });

    _mapController.move(position, 16);
  }

  void _addCustomMarker(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _selectedLocationName = 'Custom Meeting Point';
      _selectedLocationAddress = '${position.latitude}, ${position.longitude}';
    });

    _mapController.move(position, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F4E6),
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

            // Map
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _selectedLocation,
                  zoom: 15.5,
                  onTap: (tapPosition, latlng) => _addCustomMarker(latlng),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: _buildMarkers(),
                  ),
                ],
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
                  children: const [
                    SizedBox(width: 16),
                    Icon(Icons.search, color: Color(0xFF4A6741)),
                    SizedBox(width: 8),
                    Expanded(
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

            // Quick Select Buttons
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _predefinedLocations.map((location) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectLocation(
                          location['position'],
                          location['title'],
                          location['address'],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedLocationName == location['title']
                                ? const Color(0xFF4A6741)
                                : const Color(0xFFE6F4E6),
                        foregroundColor:
                            _selectedLocationName == location['title']
                                ? Colors.white
                                : const Color(0xFF4A6741),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(location['title']),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Info Section
            Padding(
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
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF4A6741)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLocationName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedLocationAddress,
                              style: const TextStyle(color: Colors.black54),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OrderdetailsAddress(), // Redirect to chat_buyer.dart
              ),
            );
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
