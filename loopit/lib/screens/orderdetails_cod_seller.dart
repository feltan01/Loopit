import 'package:flutter/material.dart';
import 'report.dart'; // Import the report screen
import 'meetingpoint.dart'; // Import the meeting point page
import 'transaction_hub.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const OrderdetailsCodSeller());
}

class OrderdetailsCodSeller extends StatelessWidget {
  const OrderdetailsCodSeller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OrderDetailsPage(),
    );
  }
}

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  // Default meeting point status
  LatLng? meetingPointLocation;
  String meetingPointAddress = 'Please set your meeting point';
  bool hasMeetingPoint = false;

  // Google Maps Controller
  GoogleMapController? _mapController;

  // Method to update meeting point data when returning from MeetingPointPage
  void _updateMeetingPoint(LatLng location, String address) {
    setState(() {
      meetingPointLocation = location;
      meetingPointAddress = address;
      hasMeetingPoint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button and title bar
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionHub(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Order details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6741),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

            // Order content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/shoes.jpg', // Replace with your actual image
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Invoice number: INV-20240223-8745',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Sepatu Staccato Original',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A6741),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Rp 550.000',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Order info section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Order info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Payment method
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 120, child: Text('Payment method')),
                          const Expanded(child: Text('Cash on delivery')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Order number
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 120, child: Text('Order number')),
                          const Expanded(child: Text('00000001')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meeting point - Modified with InkWell to make it clickable
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text('Decided meeting point'),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    // Navigate to MeetingPointPage when tapped and wait for result
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MeetingPointPage(),
                                      ),
                                    );
                                    
                                    // Check if we received meeting point data
                                    if (result != null && result is Map<String, dynamic>) {
                                      if (result.containsKey('location') && result.containsKey('address')) {
                                        _updateMeetingPoint(
                                          result['location'] as LatLng,
                                          result['address'] as String,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF1EA),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Color(0xFF4A6741),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            meetingPointAddress,
                                            style: const TextStyle(
                                              color: Color(0xFF4A6741),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 120.0, top: 4),
                            child: const Text(
                              '*once set, the buyer would be informed and '
                              'meeting point cannot be changed. please '
                              'contact the buyer for further decision '
                              'making.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Map preview - Only shown when meeting point is set
                    if (hasMeetingPoint && meetingPointLocation != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Meeting Point Location',
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A6741),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEEF1EA), width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: meetingPointLocation!,
                                    zoom: 15.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('selected_meeting_point'),
                                      position: meetingPointLocation!,
                                      infoWindow: const InfoWindow(
                                        title: 'Meeting Point',
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                  onMapCreated: (GoogleMapController controller) {
                                    _mapController = controller;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              meetingPointAddress,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Divider(
                        height: 32, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 4),

                    // Total section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6741),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Items total
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Items total'),
                          const Text('Rp 550.000'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Service fee
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Service fee'),
                          const Text('Rp 2.000'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),

                    // Final total
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Text('Rp 552.000',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Report section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text('Products/Transaction trouble?'),
                          TextButton(
                            onPressed: () {
                              // Navigate to the ReportProblemScreen when pressed
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasMeetingPoint ? () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Meeting Point'),
                          content: const Text(
                            'Once confirmed, the meeting point cannot be changed and the buyer will be notified. Are you sure?'
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle confirmation logic here
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportProblemScreen(),
                                ),
                              );
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  } : null, // Disable button if no meeting point is set
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF1EA),
                    foregroundColor: const Color(0xFF4A6741),
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Confirm',
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