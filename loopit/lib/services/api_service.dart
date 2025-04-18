import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/conversation.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.207:8000/api';

  // Token Management
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
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
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }

  // Headers with Authentication
  // Headers with Authentication
static Future<Map<String, String>> getHeaders({bool requireAuth = false}) async {
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

  // Authentication Methods
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access']);
      if (data.containsKey('refresh')) {
        await setRefreshToken(data['refresh']);
      }
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await setToken(data['token']);
      return data;
    } else {
      throw Exception('Failed to register: ${response.body}');
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
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/chat/auth/user/'),
        headers: headers,
      );

      print('User info response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        return User(
            id: -1, username: 'DefaultUser', email: 'default@example.com');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return User(
          id: -1, username: 'DefaultUser', email: 'default@example.com');
    }
  }

  // Conversations
  // Conversations
static Future<List<Conversation>> getConversations() async {
  try {
    final headers = await getHeaders(requireAuth: false); // Allow fetching without token
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
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/chat/conversations/$id/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load conversation: ${response.body}');
    }
  }

static Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
  final headers = await getHeaders(); // Assuming this requires a token
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

  static Future<Map<String, dynamic>> sendMessage(
      int conversationId, String text) async {
    final headers = await getHeaders();
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

  // Products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final headers = await getHeaders();
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

  static Future<Map<String, dynamic>> createProduct(
    String name,
    String brand,
    double price,
    String description,
    File image,
  ) async {
    final token = await getToken();
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

  // Offers
  static Future<Map<String, dynamic>> makeOffer(
    int conversationId,
    int productId,
    double amount,
  ) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/offers/'),
      headers: headers,
      body: jsonEncode({
        'conversation': conversationId,
        'product': productId,
        'amount': amount,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create offer: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> respondToOffer(
      int offerId, String status) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/offers/$offerId/respond/'),
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

  // Orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final headers = await getHeaders();
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

  static uploadListingImages(int listingId, List<File> selectedImages) {}

  static createListing(String text, String text2, String text3, String text4,
      String text5, String text6) {}

  static getAllListings() {}
}
