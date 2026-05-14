import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // LOGIN - SESUAI PDF halaman 3
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['data']['token'];
      
      // SESUAI PDF: Simpan token menggunakan flutter_secure_storage
      await _storage.write(key: 'auth_token', value: token);
      
      print('Login berhasil! Token: $token');
      return token;
    } else {
      print('Login gagal: ${response.body}');
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // SESUAI PDF halaman 4: GET /api/products
  Future<List<Product>> getProducts() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> productsData = data['data'] ?? [];
      
      // Menggunakan Class Model untuk memproses data
      return productsData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }

  // SESUAI PDF halaman 4: POST /api/products
  Future<Product> createProduct(Product product) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal menyimpan produk');
    }
  }

  // SESUAI PDF halaman 5: POST /api/products/submit
  Future<bool> submitTask(SubmitTask task) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      print('Tugas berhasil dikirim!');
      return true;
    } else {
      print('Gagal mengirim tugas: ${response.body}');
      return false;
    }
  }

  // DELETE untuk soft delete (SESUAI PDF halaman 1)
  Future<bool> deleteProduct(int id) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/$id');
    
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}