import 'package:flutter/material.dart';

/// Tag colors offered by the editor. Values are ARGB ints so they can live in
/// the pure domain and the database without Flutter imports.
const tagPalette = <int>[
  0xFFB07D5C,
  0xFF5B7F6B,
  0xFF4A6FA5,
  0xFF9A6B8F,
  0xFFC08A3E,
  0xFF6B7F9A,
  0xFF8A5A5A,
  0xFF4F7F7A,
];

Color tagColor(int value) => Color(value);
