import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  static Future<List<Product>> getProducts() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/api/products"));
      final data = jsonDecode(res.body);

      if (data["success"]) {
        return (data["data"] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        throw Exception(data["message"]);
      }
    } catch (e) {
      throw Exception("Server not reachable");
    }
  }

  static Future<Map<String, dynamic>> addProduct(String name, double price) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/products"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "price": price}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }
}