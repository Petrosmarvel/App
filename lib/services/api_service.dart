import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';

class ApiService {
  // For Android emulator: 10.0.2.2 is localhost
  // For physical device: Use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Get all products from backend
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create a new order
  static Future<Map<String, dynamic>> createOrder(List<CartItem> cartItems) async {
    try {
      final orderData = {
        "customer_name": "Walk-in Customer",
        "items": cartItems.map((item) => {
          "product_id": item.product.id,
          "quantity": item.quantity,
          "price": item.product.price,
          "modifications": item.modifications,
          "notes": item.notes
        }).toList(),
        "tax_rate": 0.16,
        "discount_percentage": 0.0
      };

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Submit invoice to tax authority
  static Future<Map<String, dynamic>> submitInvoice(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"order_id": orderId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit invoice: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get dashboard summary
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports/summary'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load dashboard summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get daily sales report
  static Future<List<dynamic>> getDailySalesReport({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports/daily-sales?days=$days'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load sales report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get tax report
  static Future<Map<String, dynamic>> getTaxReport({String? startDate, String? endDate}) async {
    try {
      String url = '$baseUrl/reports/tax';
      if (startDate != null && endDate != null) {
        url += '?start_date=$startDate&end_date=$endDate';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tax report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}// TODO Implement this library.