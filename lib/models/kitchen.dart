import 'dart:ui';

import 'package:spacecraft/models/searchdesign.dart';

class Kitchen implements SearchableItem {
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

  Kitchen({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.specification,
    this.isFavorite = false,
    required this.onTap,
    this.onDelete,
  });

  Kitchen copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    String? specification,
    bool? isFavorite,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return Kitchen(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      onTap: onTap ?? this.onTap,
      onDelete: onDelete ?? this.onDelete,
      specification: specification ?? this.specification,
    );
  }
}
