import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoopIt',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NewListingPage(),
    );
  }
}

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
                onPressed: () {
                  // Save functionality
                },
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
                    width: 45,
                    height: 45,
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
              
              const SizedBox(height: 20),
              
              // Photo Upload Area
              Center(
                child: Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAF3DC), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4E6645),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Add photos",
                        style: TextStyle(
                          color: Color(0xFF4E6645),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
  
  // Function to build text field
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