import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

class ShimmerImageLoader extends StatelessWidget {
  final double minHeight;
  final double maxHeight;

  const ShimmerImageLoader({
    super.key,
    this.minHeight = 100.0,
    this.maxHeight = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    final randomHeight =
        Random().nextDouble() * (maxHeight - minHeight) + minHeight;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: randomHeight,
        color: Colors.white,
      ),
    );
  }
}
