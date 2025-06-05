// lib/providers/product_provider.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/model/product_model.dart.dart';
import 'package:mobile_app/product_remote_datasource.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ProductRemoteDataSource _dataSource = ProductRemoteDataSource();

  ProductModel? _product;
  List<ProductModel> _allProducts = [];
  final List<ProductModel> _favorites = [];

  bool _isLoading = false;
  String? error;

  bool get isLoading => _isLoading;
  ProductModel? get product => _product;
  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get favorites => _favorites;

  // Load all products
  Future<void> loadAllProducts() async {
    _isLoading = true;
    error = null;
    notifyListeners();

    try {
      _allProducts = await _dataSource.fetchAllProducts();
    } catch (e) {
      error = "Failed to load all products";
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load a single product by ID
  Future<void> loadProduct(int id) async {
    _isLoading = true;
    error = null;
    notifyListeners();

    try {
      _product = await _dataSource.fetchProductById(id);
    } catch (e) {
      error = "Failed to load product";
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(ProductModel product) {
    final exists = _favorites.any((p) => p.id == product.id);
    if (exists) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((p) => p.id == product.id);
  }
}
