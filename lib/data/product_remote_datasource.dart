// lib/data/product_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/model/product_model.dart.dart';



class ProductRemoteDataSource {
  // Fetch all products
  Future<List<ProductModel>> fetchAllProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch a single product by ID
  Future<ProductModel> fetchProductById(int id) async {
    final url = Uri.parse('https://fakestoreapi.com/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }
}
