// lib/core/helpers/base64_image_helper.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageHelper {
  /// Returns a widget for Base64 image. If base64String is null/empty/invalid,
  /// returns a placeholder container.
  static Widget fromBase64(
      String? base64String, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.cover,
        BorderRadius? borderRadius,
        Widget? placeholder,
      }) {
    if (base64String == null || base64String.isEmpty) {
      return placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
    }

    try {
      final Uint8List bytes = base64Decode(base64String);
      final Image img = Image.memory(bytes, width: width, height: height, fit: fit);
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius, child: img);
      }
      return img;
    } catch (e) {
      return placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
    }
  }
}
