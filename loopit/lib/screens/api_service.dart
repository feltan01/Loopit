import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your Django API
  static const String baseUrl = 'http://192.168.18.50:8000';

  static get yourAccessToken => null; 
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // must match your login save
  }

  static Future<List<Map<String, dynamic>>> getAllListings() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/listings/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      } else {
        return []; // fallback to empty list
      }
    } else {
      throw Exception('Failed to load listings');
    }
  }

  static Future<bool> updateListing({
    required int listingId,
    required String title,
    required String price,
    required String category,
    required String condition,
    required String description,
    required String productAge,
  }) async {
    final url = Uri.parse('$baseUrl/api/listings/$listingId/');
    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'title': title,
      'price': int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')),
      'category': category,
      'condition': condition,
      'description': description,
      'product_age': productAge,
    });

    print("📤 PUT $url");
    print("📦 BODY: $body");
    print("🔐 TOKEN: $token");

    try {
      final response = await http.put(url, headers: headers, body: body);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Listing updated successfully");
        return true;
      } else {
        print("❌ Failed to update listing: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🔥 Exception during update: $e");
      return false;
    }
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
        'http://192.168.18.50:8000/api/listings/'); // ✅ ganti sesuai IP kamu

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
  static Future<void> uploadListingImages(
      int listingId, List<dynamic> images) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    for (var image in images) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/listings/$listingId/upload_images/'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && image is Uint8List) {
        request.files.add(
          http.MultipartFile.fromBytes('image', image,
              filename: 'web_image.jpg'),
        );
      } else if (image is File) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("UPLOAD IMAGE STATUS: ${response.statusCode}");

      if (response.statusCode != 201) {
        print("Image upload failed: ${response.body}");
      }
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

