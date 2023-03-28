import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:responsive_builder/responsive_builder.dart';

Future<Color?> getDominantColor(String imageUrl) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(imageUrl),
          size: const Size(100, 100));
  return paletteGenerator.dominantColor?.color;
}

String removeBrackets(String stringList) {
  return stringList.replaceAll('[', "").replaceAll("]", "");
}

double getValue(SizingInformation sizingInformation, Orientation orientation,
    MediaQueryData mediaQuery) {
  if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
    return 0.6;
  } else if (orientation == Orientation.landscape) {
    return 1.2;
  } else {
    return (mediaQuery.size.width / mediaQuery.size.height / 1.1);
  }
}

Color getColor(double percentage) {
  if (percentage < 0.25) {
    return Colors.red;
  } else if (percentage < 0.5) {
    return Colors.orange;
  } else if (percentage < 0.75) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}
