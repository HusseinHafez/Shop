import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.title,
    required this.id,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatu({required String? authToken,required String? userId}) async {
    final oldStatu = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldStatu;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatu;
      notifyListeners();
    }
  }
}

enum FilterOptions { favorite, all }
