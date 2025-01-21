import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:spacecraft/models/searchdesign.dart';

class Room implements SearchableItem {
  @override
  final String id;
  @override
  final String name;
  @override
  final String imageUrl;
  @override
  final String description;
  @override
  final String specification;
  @override
  bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final String type;

  Room({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.specification,
    this.isFavorite = false,
    required this.onTap,
    this.onDelete,
    this.type = 'Room',
  });

  Room copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    String? specification,
    bool? isFavorite,
    VoidCallback? onTap,
    VoidCallback? onDelete,
    String? type,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      onTap: onTap ?? this.onTap,
      onDelete: onDelete ?? this.onDelete,
      type: type ?? this.type,
      specification: specification ?? this.specification,
    );
  }

  Future<void> updateFavoriteStatusInDatabase() async {
    final databaseReference = FirebaseDatabase.instance.ref("favorite");
    final snapshot = await databaseReference.child('rooms').get();
    if (snapshot.exists) {
      await databaseReference
          .child('rooms')
          .push()
          .set({'favorite': isFavorite, 'id': id});
    } else {
      await databaseReference
          .child('rooms')
          .child(id)
          .update({'isFavorite': isFavorite});
    }
  }
}
