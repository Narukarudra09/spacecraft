import 'dart:core';

import 'package:flutter/material.dart';

import '../models/kitchen.dart';
import '../models/kitchen_state.dart';

class KitchenProvider with ChangeNotifier {
  KitchenState _state = KitchenState();
  final List<Kitchen> _Kitchen = [
    Kitchen(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "kitchen",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "kitchen",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "kitchen",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "kitchen",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
    Kitchen(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {},
        specification: ''),
  ];
  final List<String> _recentSearches = [];

  List<String> get recentSearches => _recentSearches;
  String _searchQuery = '';

  KitchenState get state => _state;

  List<Kitchen> get kitchen => _Kitchen;

  List<Kitchen> get favorites =>
      _Kitchen.where((kitchen) => kitchen.isFavorite).toList();

  String get searchQuery => _searchQuery;

  List<Kitchen> get filteredRooms => _searchQuery.isEmpty
      ? _Kitchen
      : _Kitchen.where((kitchen) =>
              kitchen.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  void _setState(KitchenState newState) {
    _state = newState;
    notifyListeners();
  }

  void _handleError(String errorMessage) {
    _setState(_state.copyWith(
      error: errorMessage,
      isLoading: false,
      isDeleting: false,
    ));
  }

  Future<void> deleteKitchen(String id) async {
    try {
      // Set deleting state
      _setState(_state.copyWith(
        isDeleting: true,
        deletingRoomId: id,
        error: null,
      ));

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Remove room
      final kitchenIndex = _Kitchen.indexWhere((kitchen) => kitchen.id == id);
      if (kitchenIndex >= 0) {
        _Kitchen.removeAt(kitchenIndex);
      }

      // Reset delete state
      _setState(_state.copyWith(
        isDeleting: false,
        deletingRoomId: null,
      ));
    } catch (e) {
      _handleError('Failed to delete room: ${e.toString()}');
    }
  }

  void setKitchens(List<Kitchen> kitchen) {
    _Kitchen.clear();
    _Kitchen.addAll(kitchen);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final kitchenIndex = _Kitchen.indexWhere((kitchen) => kitchen.id == id);
      if (kitchenIndex >= 0) {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        _Kitchen[kitchenIndex] = _Kitchen[kitchenIndex].copyWith(
          isFavorite: !_Kitchen[kitchenIndex].isFavorite,
        );
        notifyListeners();
      }
    } catch (e) {
      _handleError('Failed to update favorite status: ${e.toString()}');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> deleteKitchens(List<String> ids) async {
    try {
      _setState(_state.copyWith(isLoading: true, error: null));

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _Kitchen.removeWhere((room) => ids.contains(room.id));

      _setState(_state.copyWith(isLoading: false));
    } catch (e) {
      _handleError('Failed to delete rooms: ${e.toString()}');
    }
  }

  Future<void> addRoom(Kitchen kitchen) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _Kitchen.add(kitchen);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add room: ${e.toString()}');
    }
  }
}
