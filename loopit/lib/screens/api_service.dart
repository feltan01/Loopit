import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your Django API
  static const String baseUrl = 'http://10.10.169.101:8000';

  static get yourAccessToken => null; // Use this for Android emulator
  // For iOS simulator, use: 'http://127.0.0.1:8000'
  // For physical devices, use your actual IP address

  // Get the JWT token from shared preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // must match your login save
  }

  // Create a new listing
  static Future<Map<String, dynamic>?> createListing(
    String title,
    String price,
    String category,
    String condition,
    String description,
    String productAge,
  ) async {
    final url = Uri.parse(
        'http://10.10.169.101:8000/api/listings/'); // ✅ ganti sesuai IP kamu

    final token = await getToken();
    print("🔐 TOKEN: $token");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'title': title,
      'price': int.tryParse(price), // must be int
      'category': category,
      'condition': condition,
      'description': description,
      'product_age': productAge,
    });

    print("📤 Sending request...");
    print("📡 URL: $url");
    print("🔐 TOKEN: $token");
    print("📦 BODY: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("🔥 Exception: $e");
      return null;
    }
  }


  // Upload images to a listing
  static Future<bool> uploadListingImages(
      int listingId, List<File> images) async {
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
        'Content-Type': 'application/json',
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
        Uri.parse('$baseUrl/api/listings/'), // ✅ make sure this is correct
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch listings: ${response.statusCode} - ${response.body}');
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
        throw Exception('🚫 Token is null! Are you logged in?');
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
