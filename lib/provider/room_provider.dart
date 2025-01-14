import 'dart:core';

import 'package:flutter/material.dart';

import '../models/room.dart';
import '../models/room_state.dart';

class RoomProvider with ChangeNotifier {
  RoomState _state = RoomState();
  final List<Room> _rooms = [
    Room(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "room",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "room",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "room",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "rudra",
        imageUrl: "assets/slider/slide1.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "room",
        imageUrl: "assets/slider/slide3.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
    Room(
        id: DateTime.now().toString(),
        name: "Naruka",
        imageUrl: "assets/slider/slide2.png",
        description: "drggfshttuhendyaesrdby",
        onTap: () {}),
  ];
  String _searchQuery = '';

  RoomState get state => _state;

  List<Room> get rooms => _rooms;

  List<Room> get favorites => _rooms.where((room) => room.isFavorite).toList();

  String get searchQuery => _searchQuery;

  List<Room> get filteredRooms => _searchQuery.isEmpty
      ? _rooms
      : _rooms
          .where((room) =>
              room.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  void _setState(RoomState newState) {
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

  Future<void> deleteRoom(String id) async {
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
      final roomIndex = _rooms.indexWhere((room) => room.id == id);
      if (roomIndex >= 0) {
        _rooms.removeAt(roomIndex);
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

  void setRooms(List<Room> rooms) {
    _rooms.clear();
    _rooms.addAll(rooms);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final roomIndex = _rooms.indexWhere((room) => room.id == id);
      if (roomIndex >= 0) {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        _rooms[roomIndex] = _rooms[roomIndex].copyWith(
          isFavorite: !_rooms[roomIndex].isFavorite,
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

  Future<void> deleteRooms(List<String> ids) async {
    try {
      _setState(_state.copyWith(isLoading: true, error: null));

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _rooms.removeWhere((room) => ids.contains(room.id));

      _setState(_state.copyWith(isLoading: false));
    } catch (e) {
      _handleError('Failed to delete rooms: ${e.toString()}');
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _rooms.add(room);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add room: ${e.toString()}');
    }
  }
}
