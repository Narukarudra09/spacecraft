import 'dart:math';

import 'package:flutter/material.dart';

import '../models/searchdesign.dart';
import 'kitchen_provider.dart';
import 'room_provider.dart';

class CombinedSearchProvider with ChangeNotifier {
  final RoomProvider _roomProvider;
  final KitchenProvider _kitchenProvider;
  String _searchQuery = '';

  CombinedSearchProvider(this._roomProvider, this._kitchenProvider);

  final List<String> _recentSearches = [];

  List<String> get recentSearches => _recentSearches;

  String get searchQuery => _searchQuery;

  List<SearchableItem> get allItems {
    // No need for casting since Room and Kitchen now implement SearchableItem
    final List<SearchableItem> combined = [
      ..._roomProvider.rooms,
      ..._kitchenProvider.kitchen,
    ];

    // Shuffle the combined list
    final random = Random();
    for (var i = combined.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = combined[i];
      combined[i] = combined[j];
      combined[j] = temp;
    }

    return combined;
  }

  List<SearchableItem> get filteredItems {
    if (_searchQuery.isEmpty) return allItems;

    return allItems
        .where((item) =>
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addRecentSearch(String query) {
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) _recentSearches.removeLast();
      notifyListeners();
    }
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    notifyListeners();
  }
}
