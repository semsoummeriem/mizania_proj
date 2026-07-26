import 'package:flutter/material.dart';

class Category {
  final int? id;
  final IconData icon;
  final String name;
  final String? color;
  final bool isDefault;

  Category({
    this.id,
    required this.icon,
    required this.name,
    this.color,
    this.isDefault = false,
  });
}
