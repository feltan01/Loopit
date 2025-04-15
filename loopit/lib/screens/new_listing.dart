import 'package:flutter/material.dart';
import 'package:loopit/screens/your_listings.dart';
import 'listing_success.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:loopit/services/api_service.dart';
import 'package:flutter/foundation.dart';

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

  List<File> _selectedImages = [];
  bool _hasUploadedID = false;

  int get photoCount => _selectedImages.length;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Web: no File() support, but you can store the path for a preview
        setState(() {
          _selectedImages.add(File(
              pickedFile.path)); // This is okay for upload, but not for preview
          _hasUploadedID = true;
        });
      } else {
        // Mobile: normal File usage
        setState(() {
          _selectedImages.add(File(pickedFile.path));
          _hasUploadedID = true;
        });
      }
    }
  }

  bool _validateInputs() {
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleSave() async {
    if (_validateInputs()) {
      try {
        final listing = await ApiService.createListing(
          _titleController.text,
          _priceController.text,
          _categoryController.text,
          _conditionController.text,
          _descriptionController.text,
          _productAgeController.text,
        );

        if (listing == null || !listing.containsKey('id')) {
          _showErrorSnackBar('Failed to create listing. Invalid response.');
          return;
        }

        final int listingId = listing['id'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const YourListingPage(), // Go back to listings page
          ),
        );
      } catch (e) {
        _showErrorSnackBar('Error saving listing: $e');
      }
    }
  }

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
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
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
                onPressed: _handleSave,
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
                        image: AssetImage('assets/image.jpg'),
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

              // Image Picker Button
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF4E6645), width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFEAF3DC),
                    ),
                    child: const Icon(Icons.add_a_photo,
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

              const SizedBox(height: 10),

              // Show image previews
              if (_selectedImages.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _selectedImages.map((file) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: kIsWeb
                            ? Image.asset(
                                'assets/images/placeholder.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                file,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 16),
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
}
