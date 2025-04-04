import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // Product Title
              Text(
                'Jacket Cream color Brand ABC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              // Price
              Text(
                'Rp 250.000',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              // Quick Message Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Message Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.message, size: 20),
                        label: Text('Send seller a message'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    // Quick Messages
                    _buildQuickMessage('Hi, is this item still available?'),
                    Divider(height: 1, thickness: 1),
                    _buildQuickMessage('Send'),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Description Section
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              ..._buildDescriptionPoints(),
              SizedBox(height: 8),
              Text(
                'Product age: 1 year and a half',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),

              // Seller Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: Text('I', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User I',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: List.generate(4, (index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ))..add(Icon(
                          Icons.star,
                          color: Colors.grey[300],
                          size: 20,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Other Products
              Text(
                'Other Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildProductCard(
                      title: 'John Soku 1800',
                      price: 'Rp 400.000',
                      status: '72% Fair',
                    ),
                    SizedBox(width: 16),
                    _buildProductCard(
                      title: 'Mahan piano anak',
                      price: 'Rp 150.000',
                      status: '35% Like Now',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Components
  Widget _buildQuickMessage(String text) {
    return Container(
      color: Colors.grey[50],
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  List<Widget> _buildDescriptionPoints() {
    final points = [
      'Size M fat',
      'Cool, lightweight, soft material',
      'The latest models today',
      'Cream color',
      '2 front pockets',
      'Screen Printing Logo',
    ];
    
    return points.map((point) => Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(point, style: TextStyle(fontSize: 16))),
        ],
      ),
    )).toList();
  }

  Widget _buildProductCard({required String title, required String price, required String status}) {
    return Container(
      width: 180,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
          SizedBox(height: 6),
          Text(price, style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          )),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}