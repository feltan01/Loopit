import 'package:flutter/material.dart';
import 'package:loopit/screens/api_service.dart';

class EditListingPage extends StatefulWidget {
  final String initialTitle;
  final String initialPrice;
  final String initialCondition;
  final int listingId;

  const EditListingPage({
    super.key,
    required this.initialTitle,
    required this.initialPrice,
    required this.initialCondition,
    required this.listingId,
  });

  @override
  _EditListingPageState createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  // Controllers for text fields
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  final _categoryController = TextEditingController(text: 'Fashion / Wardrobe');
  late TextEditingController _conditionController;
  final _descriptionController = TextEditingController(
    text:
        'Sepatu Trending Staccato !!!\nLike New\nBrand New Open Box\nWarna Grey to White\nSize M fit L',
  );
  final _productAgeController = TextEditingController(text: '6 months');

  int photoCount = 1; // Assuming one photo is already uploaded

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values passed from the previous screen
    _titleController = TextEditingController(text: widget.initialTitle);
    _priceController = TextEditingController(text: widget.initialPrice);
    _conditionController = TextEditingController(text: widget.initialCondition);
  }

  // Method to save changes
  void _saveChanges() async {
    final updated = await ApiService.updateListing(
      listingId: widget.listingId,
      title: _titleController.text,
      price: _priceController.text,
      category: _categoryController.text,
      condition: _conditionController.text,
      description: _descriptionController.text,
      productAge: _productAgeController.text,
    );

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Listing updated successfully')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to update listing')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Edit Listing",
            style: TextStyle(
              color: Color(0xFF4E6645),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3DC),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4E6645)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DC),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextButton(
                onPressed: _saveChanges,
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Color(0xFF4E6645),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // User Info Row
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/default_profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "User 1",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4E6645),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Function to handle image upload
                    setState(() {
                      photoCount++; // Increment photo count
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF4E6645), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFEAF3DC),
                    ),
                    child: const Icon(Icons.add,
                        color: Color(0xFF4E6645), size: 40),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Photo Counter
              Text(
                "Photos: $photoCount/10",
                style: const TextStyle(
                  color: Color(0xFF4E6645),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              // Form Fields
              _buildTextField(_titleController, "Title"),
              _buildTextField(_priceController, "Price"),
              _buildTextField(_categoryController, "Category"),
              _buildTextField(_conditionController, "Condition"),
              _buildTextField(_descriptionController, "Description",
                  maxLines: 5),
              _buildTextField(_productAgeController, "Product age"),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Updated TextField method to match NewListingPage design
  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAF3DC), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    _productAgeController.dispose();
    super.dispose();
  }
}
