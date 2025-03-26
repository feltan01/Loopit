import 'package:flutter/material.dart';
import 'listing_success.dart'; // Make sure to import the ListingSuccessPage

class NewListingPage extends StatefulWidget {
  const NewListingPage({Key? key}) : super(key: key);

  @override
  _NewListingPageState createState() => _NewListingPageState();
}

class _NewListingPageState extends State<NewListingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productAgeController = TextEditingController();
  int photoCount = 0;
  bool _hasUploadedID = false;

  // Method to validate form inputs
  bool _validateInputs() {
    // Check if all required fields are filled
    if (_titleController.text.isEmpty) {
      _showErrorSnackBar('Please enter a title');
      return false;
    }

    if (_priceController.text.isEmpty) {
      _showErrorSnackBar('Please enter a price');
      return false;
    }

    if (_categoryController.text.isEmpty) {
      _showErrorSnackBar('Please select a category');
      return false;
    }

    if (_conditionController.text.isEmpty) {
      _showErrorSnackBar('Please specify the condition');
      return false;
    }

    if (_descriptionController.text.isEmpty) {
      _showErrorSnackBar('Please provide a description');
      return false;
    }

    if (_productAgeController.text.isEmpty) {
      _showErrorSnackBar('Please enter the product age');
      return false;
    }

    if (!_hasUploadedID || photoCount == 0) {
      _showErrorSnackBar('Please upload at least one photo');
      return false;
    }

    return true;
  }

  // Method to show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Method to handle save functionality
  void _handleSave() {
    if (_validateInputs()) {
      // If all inputs are valid, navigate to ListingSuccessPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ListingSuccessPage(
            destinationPage: const NewListingPage(), // Replace with your actual next page if different
          ),
        ),
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
            "New Listing",
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
                onPressed: _handleSave, // Updated to use _handleSave method
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
                      _hasUploadedID = true;
                      photoCount++; // Increment photo count
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF4E6645), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: _hasUploadedID
                          ? const Color(0xFFEAF3DC)
                          : Colors.transparent,
                    ),
                    child: _hasUploadedID
                        ? const Icon(Icons.check, color: Color(0xFF4E6645), size: 40)
                        : const Icon(Icons.add, color: Color(0xFF4E6645), size: 40),
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
              _buildTextField(_descriptionController, "Description", maxLines: 5),
              _buildTextField(_productAgeController, "Product age"),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Existing _buildTextField method remains the same
  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}