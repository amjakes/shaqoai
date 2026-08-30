import 'package:flutter/material.dart';

class AgentProfile {
  const AgentProfile({
    required this.name,
    required this.title,
    required this.category,
    required this.description,
    required this.capabilities,
    required this.icon,
    this.note,
  });

  final String name;
  final String title;
  final String category;
  final String description;
  final List<String> capabilities;
  final IconData icon;
  final String? note;

  String get displayName => '$name — $title';
}
