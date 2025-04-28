import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your Django API
  static const String baseUrl = 'http://192.168.18.65:8000';

  static get yourAccessToken => null;
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // must match your login save
  }

  static Future<List<Map<String, dynamic>>> getAllListings() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/api/listings/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response);
      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        } else {
          return []; // ✅ Correct for this function
        }
      } else {
        return []; // ✅ Correct type returned
      }
    } catch (e) {
      print("🔥 Exception: $e");
      return []; // ✅ Still correct type
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

  static Future<Map<String, dynamic>?> createListing(
    String title,
    String price,
    String category,
    String condition,
    String description,
    String productAge,
  ) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/listings/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'title': title,
      'price': int.tryParse(price),
      'category': category,
      'condition': condition,
      'description': description,
      'product_age': productAge,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // ✅ Correct
      } else {
        return null; // ✅ Return null on failure
      }
    } catch (e) {
      print("🔥 Exception: $e");
      return null; // ✅ Correct for this function
    }
  }

  // Upload images to a listings
  static Future<void> uploadListingImages(
      int listingId, List<dynamic> images) async {
    final token = await getToken();

    final url = Uri.parse('$baseUrl/api/listings/$listingId/upload_images/');
    var request = http.MultipartRequest('POST', url);

    // Add token to header
    request.headers['Authorization'] = 'Bearer $token';

    // Add each image to the 'images' field
    for (var i = 0; i < images.length; i++) {
      if (kIsWeb && images[i] is Uint8List) {
        request.files.add(http.MultipartFile.fromBytes(
          'images', // Note: plural to match Django's 'getlist'
          images[i],
          filename: 'web_image_$i.jpg',
        ));
      } else if (images[i] is File) {
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Note: plural
          images[i].path,
        ));
      }
    }

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("UPLOAD IMAGE STATUS: ${response.statusCode}");
    print("UPLOAD IMAGE RESPONSE: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("❌ Image upload failed: ${response.body}");
      throw Exception('Image upload failed: ${response.statusCode}');
    } else {
      print("✅ Images uploaded successfully.");
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
      final url = '$baseUrl/api/listings/$listingId/';
      print("🚀 DELETE URL: $url");

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("🗑️ DELETE Status: ${response.statusCode}");
      print("🗑️ DELETE Body: ${response.body}");

      return response.statusCode == 204;
    } catch (e) {
      print('🔥 Delete exception: $e');
      return false;
    }
  }
}
