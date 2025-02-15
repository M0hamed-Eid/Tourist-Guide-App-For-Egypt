/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/abu_simbel.png
  AssetGenImage get abuSimbel =>
      const AssetGenImage('assets/images/abu_simbel.png');

  /// File path: assets/images/cairo.png
  AssetGenImage get cairo => const AssetGenImage('assets/images/cairo.png');

  /// File path: assets/images/citadel.png
  AssetGenImage get citadel => const AssetGenImage('assets/images/citadel.png');

  /// File path: assets/images/karnak.png
  AssetGenImage get karnak => const AssetGenImage('assets/images/karnak.png');

  /// File path: assets/images/khan_khalili.png
  AssetGenImage get khanKhalili =>
      const AssetGenImage('assets/images/khan_khalili.png');

  /// File path: assets/images/library.png
  AssetGenImage get library => const AssetGenImage('assets/images/library.png');

  /// File path: assets/images/luxor.png
  AssetGenImage get luxor => const AssetGenImage('assets/images/luxor.png');

  /// File path: assets/images/museum.png
  AssetGenImage get museum => const AssetGenImage('assets/images/museum.png');

  /// File path: assets/images/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/images/profile.png');

  /// File path: assets/images/pyramids.png
  AssetGenImage get pyramids =>
      const AssetGenImage('assets/images/pyramids.png');

  /// File path: assets/images/qaitbay.png
  AssetGenImage get qaitbay => const AssetGenImage('assets/images/qaitbay.png');

  /// File path: assets/images/siwa.png
  AssetGenImage get siwa => const AssetGenImage('assets/images/siwa.png');

  /// File path: assets/images/valley_kings.png
  AssetGenImage get valleyKings =>
      const AssetGenImage('assets/images/valley_kings.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        abuSimbel,
        cairo,
        citadel,
        karnak,
        khanKhalili,
        library,
        luxor,
        museum,
        profile,
        pyramids,
        qaitbay,
        siwa,
        valleyKings
      ];

  AssetGenImage getByPath(String imageAsset) {
    return values.firstWhere(
      (image) => image._assetName == imageAsset,
      orElse: () => cairo, // return cairo as a placeholder
    );
  }
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
