// import 'package:flutter/material.dart';
// import 'package:loopit/main.dart';
// import 'package:loopit/screens/items_detail.dart';


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
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const SavedProductPage(),
//     );
//   }
// }

// class SavedProductPage extends StatelessWidget {
//   const SavedProductPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.green),
//           onPressed: () {
//             // Navigate to the existing items_details.dart file
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const ItemsDetails(),
//               ),
//             );
//           },
//         ),
//         title: const Text(
//           'Saved Items',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w500,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Column(
//           children: [
//             SavedItemCard(
//               imageUrl: 'assets/jacket.png',
//               itemName: 'Jacket Cream color',
//               brand: 'Brand ABC',
//               price: 'Rp 250.000',
//               isAvailable: true,
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const ItemsDetails(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SavedItemCard extends StatelessWidget {
//   final String imageUrl;
//   final String itemName;
//   final String brand;
//   final String price;
//   final bool isAvailable;
//   final VoidCallback onTap;

//   const SavedItemCard({
//     Key? key, 
//     required this.imageUrl,
//     required this.itemName,
//     required this.brand,
//     required this.price,
//     required this.isAvailable,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8.0),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF9F5F1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               // Product Image
//               Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: Image.asset(imageUrl, fit: BoxFit.cover),
//                   // You could replace this with a placeholder in a real app
//                   // Image.network(imageUrl, fit: BoxFit.cover),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Product Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       itemName,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       brand,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Text(
//                           price,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         if (isAvailable)
//                           Text(
//                             'Available',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Delete Button
//               IconButton(
//                 icon: const Icon(
//                   Icons.delete_outline,
//                   color: Colors.green,
//                   size: 22,
//                 ),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }