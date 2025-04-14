import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/offer.dart';
import '../models/product.dart';
import '../models/order.dart';

class ApiService {
  // Base URL of your Django backend
  static const String baseUrl = 'http://10.0.2.2:8000/api/chat'; // for Android emulator
  // Use 'http://localhost:8000/api/chat' for iOS simulator or web
  
  // Get token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // Set token in SharedPreferences
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  // Clear token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  
  // HTTP headers with authentication
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }
  
  // User Authentication
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
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
  
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['token']);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
  
  static Future<void> logout() async {
    final headers = await getHeaders();
    await http.post(
      Uri.parse('$baseUrl/auth/logout/'),
      headers: headers,
    );
    await clearToken();
  }
  
  static Future<Map<String, dynamic>> getUserInfo() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/user/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user info');
    }
  }
  
  // Conversations
  static Future<List<Map<String, dynamic>>> getConversations() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load conversations');
    }
  }
  
  static Future<Map<String, dynamic>> getConversation(int id) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$id/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load conversation');
    }
  }
  
  static Future<Map<String, dynamic>> startConversation(int userId) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/conversations/start/'),
      headers: headers,
      body: jsonEncode({
        'user_id': userId,
      }),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to start conversation');
    }
  }
  
  // Messages
  static Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/messages/?conversation=$conversationId'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load messages');
    }
  }
  
  static Future<Map<String, dynamic>> sendMessage(int conversationId, String text) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/messages/'),
      headers: headers,
      body: jsonEncode({
        'conversation': conversationId,
        'text': text,
      }),
    );
    
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }
  
  // Products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products');
    }
  }
  
  static Future<Map<String, dynamic>> getProduct(int id) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }
  
  static Future<Map<String, dynamic>> createProduct(
    String name, 
    String brand, 
    double price, 
    String description, 
    File image
  ) async {
    final token = await getToken();
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('$baseUrl/products/')
    );
    
    request.headers.addAll({
      'Authorization': 'Token $token',
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
  static Future<Map<String, dynamic>> createOffer(
    int conversationId, 
    int productId, 
    double amount
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
      throw Exception('Failed to create offer');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getOffers() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/offers/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load offers');
    }
  }
  
  static Future<Map<String, dynamic>> respondToOffer(int offerId, String response) async {
    final headers = await getHeaders();
    final apiResponse = await http.post(
      Uri.parse('$baseUrl/offers/$offerId/respond/'),
      headers: headers,
      body: jsonEncode({
        'response': response, // 'ACCEPTED' or 'REJECTED'
      }),
    );
    
    if (apiResponse.statusCode == 200) {
      return jsonDecode(apiResponse.body);
    } else {
      throw Exception('Failed to respond to offer');
    }
  }
  
  // Orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/orders/'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load orders');
    }
  }
  
  static Future<Map<String, dynamic>> updateOrderStatus(int orderId, String status) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderId/update_status/'),
      headers: headers,
      body: jsonEncode({
        'status': status, // 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED'
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update order status');
    }
  }

  static makeOffer(int conversationId, int id, double amount) {}
}