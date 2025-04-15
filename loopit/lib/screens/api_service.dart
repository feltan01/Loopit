import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your Django API
  static const String baseUrl = 'http://10.10.169.104:8000'; // Use this for Android emulator
  // For iOS simulator, use: 'http://127.0.0.1:8000'
  // For physical devices, use your actual IP address

  // Get the JWT token from shared preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Create a new listing
  static Future<Map<String, dynamic>> createListing(
      String title,
      String price,
      String category,
      String condition,
      String description,
      String productAge) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/listings/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'price': price.replaceAll('Rp ', '').replaceAll('.', ''),
          'category': category,
          'condition': condition,
          'description': description,
          'product_age': productAge,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to create listing: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating listing: $e');
    }
  }

  // Upload images to a listing
  static Future<bool> uploadListingImages(int listingId, List<File> images) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/listings/$listingId/upload_images/'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
        ));
      }

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }

  // Get user's listings
  static Future<List<dynamic>> getMyListings() async {
  try {
    final token = await getToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/listings/my_listings/'), 
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch listings: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    throw Exception('Error fetching listings: $e');
  }
}


  // Delete a listing
  static Future<bool> deleteListing(int listingId) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/listings/$listingId/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting listing: $e');
    }
  }
}