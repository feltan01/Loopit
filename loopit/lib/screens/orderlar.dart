import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/offer.dart';
import 'review.dart'; // <-- point to RatingScreen

class OrderDetailScreen extends StatelessWidget {
  final Offer offer;
  final String totalCost;
  
  const OrderDetailScreen({
    Key? key,
    required this.offer,
    required this.totalCost,
  }) : super(key: key);
  
  String formatCurrency(double amount) {
    return 'Rp ${NumberFormat('#,###', 'id').format(amount).replaceAll(',', '.')}';
  }
  
  @override
  Widget build(BuildContext context) {
    final product = offer.product;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE9F1E7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4D6A56)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(
            color: Color(0xFF4D6A56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Info
                  const Text(
                    'Delivery information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Standard shipping: 1Z3X8Y9A0456781234',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildShippingCard(),
                  const SizedBox(height: 20),
                  
                  // Delivery Address
                  const Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildAddressInfo(),
                  const SizedBox(height: 20),
                  
                  // Item Detail
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),
                  const Text(
                    'Item Detail',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 4),
                  _buildInvoiceRow(),
                  const SizedBox(height: 10),
                  _buildProductInfo(product),
                  const SizedBox(height: 20),
                  
                  // Payment Method
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentMethod(),
                  const SizedBox(height: 20),
                  
                  // Order Total
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4D6A56)
                    )
                  ),
                  const SizedBox(height: 10),
                  _buildOrderSummary(),
                  _buildTotalCost(),
                ],
              ),
            ),
          ),
          
          // Bottom button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLeaveReviewButton(
              context,
              product.name,
              product.fullImageUrl,
              formatCurrency(offer.amount),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildShippingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1E7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_shipping_outlined, color: Color(0xFF4D6A56), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your order has arrived at the transit location in Kab. Tangerang, Pagedangan, Pagedangan Hub.',
              style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56)),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddressInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF4D6A56)),
            SizedBox(width: 10),
            Text(
              'Home sweet home',
              style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 34.0),
          child: Text(
            'Edu Town Kavling Edu I No. 1, Jalan BSD Raya Utama, BSD City, Serpong, Tangerang Selatan, Banten 15345, Indonesia',
            style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56)),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInvoiceRow() {
    return Row(
      children: const [
        Text(
          'Invoice number: ',
          style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56))
        ),
        Text(
          'INV-20240223-8745',
          style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56))
        ),
      ],
    );
  }
  
  Widget _buildProductInfo(product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F2ED),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.fullImageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image)
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56)
                )
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(offer.amount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D6A56)
                )
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.imgur.com/B4Jzrx1.jpg'),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'User 1',
                    style: TextStyle(fontSize: 16)
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star_border, color: Colors.amber, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F1E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF4D6A56),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPaymentMethod() {
    return Row(
      children: [
        Container(
          height: 30,
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              "BCA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'BCA Virtual Account',
          style: TextStyle(fontSize: 16, color: Color(0xFF4D6A56))
        ),
      ],
    );
  }
  
  Widget _buildOrderSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Items Total',
              style: TextStyle(fontSize: 16, color: Colors.black87)
            ),
            Text(
              formatCurrency(offer.amount),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87
              )
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Cost',
              style: TextStyle(fontSize: 16, color: Colors.black87)
            ),
            Text(
              'Rp 45.000',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87
              )
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Service Fee',
              style: TextStyle(fontSize: 16, color: Colors.black87)
            ),
            Text(
              'Rp 2.000',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87
              )
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildTotalCost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Cost',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D6A56)
          )
        ),
        Text(
          totalCost,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4D6A56)
          )
        ),
      ],
    );
  }
  
  Widget _buildLeaveReviewButton(BuildContext context, String productName,
      String productImageUrl, String productPrice) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RatingScreen(
                productName: productName,
                productImageUrl: productImageUrl,
                productPrice: productPrice,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9F1E7),
          foregroundColor: const Color(0xFF4D6A56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text(
          'Leave a Review',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}