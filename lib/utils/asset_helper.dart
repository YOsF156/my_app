import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data' show Uint8List;

class AssetHelper {
  static Widget loadSvg(String assetPath, {double? width, double? height}) {
    try {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
      );
    } catch (e) {
      debugPrint('Error loading SVG: $e');
      return Container(
        width: width,
        height: height,
        color: Colors.transparent,
      );
    }
  }
  
  static ImageProvider loadImage(String assetPath) {
    try {
      return AssetImage(assetPath);
    } catch (e) {
      debugPrint('Error loading image: $e');
      // Return a transparent pixel as fallback
      return MemoryImage(Uint8List.fromList([0, 0, 0, 0]));
    }
  }
} 