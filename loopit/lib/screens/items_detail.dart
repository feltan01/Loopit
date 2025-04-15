// import 'package:flutter/material.dart';
// import 'package:loopit/screens/chat_buyer.dart';
// import 'package:loopit/screens/fashion_page.dart';
// import 'package:loopit/screens/saved_products.dart';
// import 'package:loopit/screens/saved_products.dart'; // Added import for saved_products.dart

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       ),
//       home: const ItemsDetails(),
//     );
//   }
// }

// class ItemsDetails extends StatefulWidget {
//   const ItemsDetails({Key? key}) : super(key: key);

//   @override
//   State<ItemsDetails> createState() => _ItemsDetailsState();
// }

// class _ItemsDetailsState extends State<ItemsDetails> {
//   bool isFavorite = false;
//   // Add a controller for the message text field
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void dispose() {
//     // Dispose the controller when the widget is removed
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8F5E9), // Light green background color
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 57, 110, 58), size: 20),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const FashionPage(),
//                 ),
//               );
//             },
//           ),
//         ),
//         title: Container(
//           height: 38,
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8F5E9),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: TextField(
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(vertical: 0),
//               prefixIcon:
//                   const Icon(Icons.search, size: 20, color: Color.fromARGB(255, 57, 110, 58)),
//               hintText: 'Search it, Loop it',
//               hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 57, 110, 58)),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           // Updated heart button with circular background - fixed styling
//           Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE8F5E9), // Light green background color
//               shape: BoxShape.circle,
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.favorite_border,
//                   color: Color.fromARGB(255, 57, 110, 58), size: 20),
//               iconSize: 20,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SavedProductPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 8), // Add a bit of padding on the right side
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 320,
//                   color: const Color(0xFFFCECEE),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                   child: Center(
//                     child: Image.network(
//                       'https://via.placeholder.com/250x250',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: 10,
//                   top: 140,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 16,
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       icon: const Icon(Icons.arrow_forward_ios,
//                           size: 16, color: Colors.green),
//                       onPressed: () {
//                         // Next image navigation logic here
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Jacket Cream color Brand ABC',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Rp 250.000',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Message input area
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Send seller a message',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 8),
//                                 // Replace static text with TextField
//                                 child: TextField(
//                                   controller: _messageController,
//                                   decoration: const InputDecoration(
//                                     hintText:
//                                         'Hi, is this item still available?',
//                                     hintStyle: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                     border: InputBorder.none,
//                                     isDense: true,
//                                     contentPadding: EdgeInsets.zero,
//                                   ),
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             // Updated Send button with Ink and InkWell for press effect
//                             Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   // When "Send" button is pressed, navigate to ChatBuyerScreen
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ChatDetailScreen(),
//                                     ),
//                                   );
//                                   // Removed snackbar feedback
//                                 },
//                                 // Add visual feedback effects
//                                 splashColor: Colors.white.withOpacity(0.3),
//                                 highlightColor: Colors.green.shade700,
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromARGB(255, 38, 88, 38),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 8),
//                                   child: const Text(
//                                     'Send',
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 255, 255, 255),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Action buttons - MODIFIED TO HAVE CIRCULAR HOVER EFFECTS
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Send offer button with circular hover
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 3 - 16,
//                         child: Column(
//                           children: [
//                             Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => const ChatDetailScreen(),
//                                   ),
//                                  );
//                                 },
//                                 // Circular splash and highlight effects
//                                 borderRadius: BorderRadius.circular(20),
//                                 splashColor: Colors.green.withOpacity(0.3),
//                                 highlightColor: Colors.green.withOpacity(0.1),
//                                 child: Ink(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFFE8F5E9),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Center(
//                                     child: Icon(Icons.local_offer_outlined,
//                                         color: Color.fromARGB(255, 38, 87, 39),
//                                         size: 20),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Send offer',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Share button with circular hover
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 3 - 16,
//                         child: Column(
//                           children: [
//                             Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   // Add your share logic here
//                                   // Removed snackbar feedback
//                                 },
//                                 // Circular splash and highlight effects
//                                 borderRadius: BorderRadius.circular(20),
//                                 splashColor: Colors.green.withOpacity(0.3),
//                                 highlightColor: Colors.green.withOpacity(0.1),
//                                 child: Ink(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFFE8F5E9),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Center(
//                                     child: Icon(Icons.share_outlined,
//                                         color: Color.fromARGB(255, 37, 81, 39),
//                                         size: 20),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Share',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Save button with circular hover - Updated to navigate to SavedProductsPage
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 3 - 16,
//                         child: Column(
//                           children: [
//                             Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {},
//                                 // Circular splash and highlight effects
//                                 borderRadius: BorderRadius.circular(20),
//                                 splashColor: Colors.green.withOpacity(0.3),
//                                 highlightColor: Colors.green.withOpacity(0.1),
//                                 child: Ink(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xFFE8F5E9),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Center(
//                                     child: Icon(
//                                       Icons.favorite_border,
//                                       color: Color.fromARGB(255, 42, 87, 44),
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Save',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Description and Condition sections
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Description section
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               'Description',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Size M (38)',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             Text(
//                               'The Material: soft material',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             Text(
//                               'The brand maybe today',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             Text(
//                               'Cream Color',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             Text(
//                               '2 front pockets',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             Text(
//                               'Screen Printing Logo',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Listed on 23rd January 2025',
//                               style:
//                                   TextStyle(fontSize: 12, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Condition section
//                       Column(
//                         children: [
//                           const Text(
//                             'Condition',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             width: 48,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               color: Colors.amber.shade100,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 '77%',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.amber,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           const Text(
//                             'Good',
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Seller Information - Removed follow button
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Seller Information',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.purple.shade100,
//                             radius: 20,
//                           ),
//                           const SizedBox(width: 12),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'User 1',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Row(
//                                 children: const [
//                                   Icon(Icons.star,
//                                       color: Colors.amber, size: 16),
//                                   Icon(Icons.star,
//                                       color: Colors.amber, size: 16),
//                                   Icon(Icons.star,
//                                       color: Colors.amber, size: 16),
//                                   Icon(Icons.star,
//                                       color: Colors.amber, size: 16),
//                                   Icon(Icons.star_half,
//                                       color: Colors.amber, size: 16),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Other Products - UPDATED to make items pressable without feedback messages
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Other Products',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // GridView to display products with proper square dimensions
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                           childAspectRatio: 0.75,
//                         ),
//                         itemCount: 4, // Number of products to display
//                         itemBuilder: (context, index) {
//                           // Product data - replace with your actual data source
//                           final products = [
//                             {
//                               'title': 'Jam Saku 1800',
//                               'price': 'Rp 400.000',
//                               'condition': '75% Fair',
//                               'badgeColor': Colors.amber.shade100,
//                               'badgeTextColor': Colors.amber.shade800,
//                               'id': '001',
//                             },
//                             {
//                               'title': 'Mainan piano anak',
//                               'price': 'Rp 150.000',
//                               'condition': '95% Like New',
//                               'badgeColor': Colors.green.shade100,
//                               'badgeTextColor': Colors.green.shade800,
//                               'id': '002',
//                             },
//                             {
//                               'title': 'Hot Toys Ant-Man Figure',
//                               'price': 'Rp 2.500.000',
//                               'condition': '98% Like New',
//                               'badgeColor': Colors.green.shade100,
//                               'badgeTextColor': Colors.green.shade800,
//                               'id': '003',
//                             },
//                             {
//                               'title': 'Jam Kate Spade Leather',
//                               'price': 'Rp 900.000',
//                               'condition': '93% Like New',
//                               'badgeColor': Colors.green.shade100,
//                               'badgeTextColor': Colors.green.shade800,
//                               'id': '004',
//                             },
//                           ];

//                           final product = products[index];

//                           return _buildPressableProductItem(
//                             product['title'] as String,
//                             product['price'] as String,
//                             product['condition'] as String,
//                             product['badgeColor'] as Color,
//                             product['badgeTextColor'] as Color,
//                             product['id'] as String,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Updated pressable product item widget without feedback messages
//   Widget _buildPressableProductItem(
//     String title,
//     String price,
//     String condition,
//     Color badgeColor,
//     Color badgeTextColor,
//     String productId,
//   ) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           // Here you would navigate to the product detail page
//           // For example:
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => ProductDetailPage(productId: productId),
//           //   ),
//           // );
//         },
//         // Visual feedback when pressed
//         borderRadius: BorderRadius.circular(8),
//         splashColor: Colors.green.withOpacity(0.3),
//         highlightColor: Colors.green.withOpacity(0.1),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Square image with proper aspect ratio
//               AspectRatio(
//                 aspectRatio: 1.0, // Perfect square ratio
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       topRight: Radius.circular(8),
//                     ),
//                   ),
//                   child: const Center(
//                     child:
//                         Text('[Image]', style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ),
//               // Product details in compact form
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize:
//                       MainAxisSize.min, // Keep column only as tall as needed
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       price,
//                       style: const TextStyle(fontSize: 10),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 4, vertical: 1),
//                           decoration: BoxDecoration(
//                             color: badgeColor,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             condition,
//                             style: TextStyle(
//                               fontSize: 9,
//                               color: badgeTextColor,
//                             ),
//                           ),
//                         ),
//                         // Make the options icon also interactive without feedback
//                         GestureDetector(
//                           onTap: () {
//                             // Show options menu when more icon is tapped
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return SafeArea(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       ListTile(
//                                         leading:
//                                             const Icon(Icons.favorite_border),
//                                         title: const Text('Add to favorites'),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                           // Action without feedback
//                                         },
//                                       ),
//                                       ListTile(
//                                         leading: const Icon(Icons.share),
//                                         title: const Text('Share product'),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                           // Action without feedback
//                                         },
//                                       ),
//                                       ListTile(
//                                         leading:
//                                             const Icon(Icons.report_outlined),
//                                         title: const Text('Report item'),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                           // Action without feedback
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                           child: const Icon(Icons.more_horiz, size: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
