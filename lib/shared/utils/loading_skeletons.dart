import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.15),
      highlightColor: const Color(0xFFC0C0C0),
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.15),
      highlightColor: const Color(0xFFC0C0C0),
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
