import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionModel {
  final String title;
  final String subtitle;
  final String icon;
  final RxBool isCompleted;
  final VoidCallback onTap;

  SectionModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
    required this.onTap,
  });
}
