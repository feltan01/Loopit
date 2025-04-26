import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/conversation.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.29:8000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    
    // Debugging log untuk memeriksa token yang didapat
    print('Token retrieved: $token');
    
    return token;
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');  // Fixed key name
    await prefs.remove('refresh_token');
  }

  // Headers with Authentication
  static Future<Map<String, String>> getHeaders({bool requireAuth = true}) async {
    if (requireAuth) {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  static Future<Map<String, dynamic>> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access']);
      return data;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await getHeaders();
      await http.post(
        Uri.parse('$baseUrl/chat/auth/logout/'),
        headers: headers,
      );
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      await clearTokens();
    }
  }

  // User Information
  static Future<User> getUserInfo() async {
    try {
      // Get and validate token
      final token = await getToken();
      if (token == null || token.isEmpty) {
        print('ERROR: No authentication token available');
        throw Exception('No authentication token available');
      }
      
      print('Token found (first 10 chars): ${token.substring(0, min(10, token.length))}...');
      
      // Use the exact URL from the browser
      final url = '$baseUrl/chat/auth/user/';
      print('Making request to: $url');
      
      // Explicitly set up headers with Bearer prefix
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request headers: $headers');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        print('Authentication failed. Token might be invalid or expired.');
        // Try to refresh token
        try {
          await refreshAccessToken();
          // Retry with the new token
          return await getUserInfo();
        } catch (refreshError) {
          print('Token refresh failed: $refreshError');
          throw Exception('Authentication failed: ${response.body}');
        }
      } else {
        throw Exception('Failed to get user info: ${response.body}');
      }
    } catch (e) {
      print('Error in getUserInfo: $e');
      return User(id: -1, username: 'DefaultUser', email: 'default@example.com');
    }
  }

  // Conversations
  static Future<List<Conversation>> getConversations() async {
    try {
      final headers = await getHeaders(requireAuth: true);
      final response = await http.get(
        Uri.parse('$baseUrl/chat/conversations/'),
        headers: headers,
      );

      print('📊 Conversations Response Status: ${response.statusCode}');
      print('📄 Conversations Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load conversations: ${response.body}');
      }
    } catch (e) {
      print('❌ Conversations Fetch Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getConversation(int id) async {
  try {
    print('📥 Getting conversation with ID: $id');
    
    final headers = await getHeaders(requireAuth: true);
    print('🔑 Headers obtained with token');
    
    final response = await http.get(
      Uri.parse('$baseUrl/chat/conversations/$id/'),
      headers: headers,
    );
    
    print('📊 Conversation response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('📄 Conversation data parsed successfully');
        
        // Check the structure of the data
        if (data is Map<String, dynamic>) {
          print('🔍 Conversation keys: ${data.keys.toList()}');
          
          // Check messages array
          if (data.containsKey('messages')) {
            if (data['messages'] == null) {
              print('⚠️ Messages is null');
            } else if (data['messages'] is List) {
              print('📝 Messages count: ${data['messages'].length}');
              
              // Check first message if available
              if (data['messages'].isNotEmpty) {
                final firstMsg = data['messages'][0];
                print('🔍 First message keys: ${firstMsg.keys.toList()}');
                
                // Check required fields
                print('ID: ${firstMsg['id'] ?? 'NULL'}');
                print('conversation: ${firstMsg['conversation'] ?? 'NULL'}');
                print('text: ${firstMsg['text'] != null ? 'Present' : 'NULL'}');
                print('created_at: ${firstMsg['created_at'] ?? 'NULL'}');
                
                // Check sender
                if (firstMsg['sender'] != null) {
                  print('sender keys: ${firstMsg['sender'].keys.toList()}');
                } else {
                  print('⚠️ sender is NULL');
                }
              }
            } else {
              print('⚠️ Messages is not a List: ${data['messages'].runtimeType}');
            }
          } else {
            print('⚠️ No messages key in response');
          }
        } else {
          print('⚠️ Response is not a Map: ${data.runtimeType}');
        }
        
        return data;
      } catch (jsonError) {
        print('❌ JSON parsing error: $jsonError');
        print('❌ Raw response body: ${response.body.substring(0, min(100, response.body.length))}...');
        rethrow;
      }
    } else {
      print('❌ API error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception('Failed to load conversation: ${response.body}');
    }
  } catch (e) {
    print('❌ Error in getConversation: $e');
    if (e is Error) {
      print('❌ Stack trace: ${e.stackTrace}');
    }
    rethrow;
  }
}
  static Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final headers = await getHeaders(requireAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/chat/messages/?conversation=$conversationId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body);
      if (data == null) {
        return []; // Return an empty list if data is null
      }
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load messages: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<Map<String, dynamic>> sendMessage(
      int conversationId, String text, [String? token]) async {
    final headers = await getHeaders(requireAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/chat/messages/'),
      headers: headers,
      body: jsonEncode({
        'conversation': conversationId,
        'text': text,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<List<Map<String, dynamic>>> getProducts([String? token]) async {
    final headers = await getHeaders(requireAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/chat/products/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<Map<String, dynamic>> createProduct(
    String name,
    String brand,
    double price,
    String description,
    File image,
    [String? token]
  ) async {
    token ??= await getToken();
    if (token == null) {
      throw Exception('No authentication token available');
    }
    
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/chat/products/'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields['name'] = name;
    request.fields['brand'] = brand;
    request.fields['price'] = price.toString();
    request.fields['description'] = description;

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<Map<String, dynamic>> makeOffer(
  int conversationId,
  int productId,
  double amount,
  [String? token]
) async {
  final headers = await getHeaders(requireAuth: true);
  print("📤 Making offer - conversation: $conversationId, product: $productId, amount: $amount");
  
  final response = await http.post(
    Uri.parse('$baseUrl/chat/offers/'),
    headers: headers,
    body: jsonEncode({
      'conversation': conversationId,
      'product': productId,
      'amount': amount,
    }),
  );

  print("📊 Offer response status: ${response.statusCode}");
  
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print("✅ Offer created successfully");
    
    // Inspect the response data structure
    if (data['product'] != null) {
      print("📦 Product in response: ${data['product']}");
      // Check if image exists in the product data
      if (data['product']['image'] != null) {
        print("🖼️ Image in product response: ${data['product']['image']}");
      } else {
        print("⚠️ No image in product response!");
      }
    }
    
    return data;
  } else {
    print("❌ Failed to create offer: ${response.body}");
    throw Exception('Failed to create offer: ${response.body}');
  }
}

  // Updated to make token parameter optional
  static Future<Map<String, dynamic>> respondToOffer(
      int offerId, String status, [String? token]) async {
    final headers = await getHeaders(requireAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/chat/offers/$offerId/respond/'),
      headers: headers,
      body: jsonEncode({
        'response': status, // 'ACCEPTED' or 'REJECTED'
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to respond to offer: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<List<Map<String, dynamic>>> getOrders([String? token]) async {
    final headers = await getHeaders(requireAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/chat/orders/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  // Updated to make token parameter optional
  static Future<void> uploadListingImages(
      int listingId, List<File> selectedImages, [String? token]) async {
    // Implementation needed
  }

  // Updated to make token parameter optional
  static Future<Map<String, dynamic>> createListing(
    String title, 
    String description, 
    String category, 
    String condition, 
    String price,
    String location,
    [String? token]
  ) async {
    // Implementation needed
    return {};
  }

  static getAllListings() {}
}