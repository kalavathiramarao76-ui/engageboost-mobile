import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_optimization.dart';

class FavoritesModel extends ChangeNotifier {
  List<PostOptimization> _favorites = [];
  String _filter = 'all';

  List<PostOptimization> get favorites {
    if (_filter == 'all') return _favorites;
    return _favorites.where((f) => f.type == _filter).toList();
  }

  List<PostOptimization> get allFavorites => _favorites;
  String get filter => _filter;

  FavoritesModel() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favorites');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _favorites = decoded.map((e) => PostOptimization.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString('favorites', data);
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((f) => f.id == id);
  }

  Future<void> toggleFavorite(PostOptimization optimization) async {
    final exists = _favorites.any((f) => f.id == optimization.id);
    if (exists) {
      _favorites.removeWhere((f) => f.id == optimization.id);
    } else {
      _favorites.insert(0, optimization);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }
}
