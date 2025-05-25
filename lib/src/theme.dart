import 'package:any_loading/src/any_loading_layer.dart';
import 'package:flutter/material.dart';

import 'any_loading_animation.dart';

/// loading mask type
/// [none] default mask type, allow user interactions while loading is displayed
/// [clear] or [black] or [custom] don't allow user interactions while loading is displayed
enum AnyLoadingMaskType {
  none,
  clear,
  black,
  custom,
}

/// IndicatorType
enum AnyLoadingIndicatorType {
  wave,
  rotatingPlain,
  doubleBounce,
  wanderingCubes,
  fadingFour,
  fadingCube,
  pulse,
  chasingDots,
  threeBounce,
  circle,
  cubeGrid,
  fadingCircle,
  rotatingCircle,
  foldingCube,
  pumpingHeart,
  hourGlass,
  pouringHourGlass,
  pouringHourGlassRefined,
  fadingGrid,
  ring,
  ripple,
  spinningCircle,
  spinningLines,
  squareCircle,
  dualRing,
  pianoWave,
  dancingSquare,
  threeInOut,
  waveSpinner,
  pulsingGrid
}

/// IndicatorStyle used for [AnyLoadingIndicator].
class AnyLoadingIndicatorStyle {
  /// default success icon for [AnyLoading.showSuccess]
  static const Icon defaultSuccessIcon = Icon(
    Icons.done,
    size: defaultIndicatorSize,
    color: Colors.white,
  );

  /// default success icon for [AnyLoading.showError]
  static const Icon defaultErrorIcon = Icon(
    Icons.error,
    size: defaultIndicatorSize,
    color: Colors.red,
  );

  /// default size of indicator
  static const double defaultIndicatorSize = 40;

  /// indicatorType
  final AnyLoadingIndicatorType indicatorType;

  /// color
  final Color? color;

  /// size
  final double size;

  /// only used for wanderingCubes or fadingFour or fadingGrid or spinningCircle
  final BoxShape? shape;

  /// only used for spinKitWave or spinningLines or pianoWave
  final int? itemCount;

  /// only used for pouringHourGlass or pouringHourGlassRefined
  final double? strokeWidth;

  /// only used for ring or spinningLines or dualRing
  final double? lineWidth;

  /// only used for threeInOut
  final Duration? delay;

  /// only used for ripple
  final double? borderWidth;

  /// only used for WaveSpinner
  final Color? trackColor;

  /// only used for WaveSpinner
  final Color? waveColor;

  const AnyLoadingIndicatorStyle({
    this.indicatorType = AnyLoadingIndicatorType.circle,
    this.color,
    this.size = defaultIndicatorSize,
    this.shape,
    this.itemCount,
    this.strokeWidth,
    this.lineWidth,
    this.borderWidth,
    this.delay,
    this.trackColor,
    this.waveColor,
  });

  factory AnyLoadingIndicatorStyle.dark(
          {BoxShape? shape,
          int? itemCount,
          double? strokeWidth,
          double? lineWidth,
          double? borderWidth,
          Duration? delay,
          AnyLoadingIndicatorType indicatorType =
              AnyLoadingIndicatorType.circle,
          double size = defaultIndicatorSize}) =>
      AnyLoadingIndicatorStyle(
          indicatorType: indicatorType,
          size: size,
          shape: shape,
          strokeWidth: strokeWidth,
          itemCount: itemCount,
          lineWidth: lineWidth,
          borderWidth: borderWidth,
          delay: delay,
          color: Colors.white);

  factory AnyLoadingIndicatorStyle.light(
          {BoxShape? shape,
          int? itemCount,
          double? strokeWidth,
          double? lineWidth,
          double? borderWidth,
          Duration? delay,
          AnyLoadingIndicatorType indicatorType =
              AnyLoadingIndicatorType.circle,
          double size = defaultIndicatorSize}) =>
      AnyLoadingIndicatorStyle(
          indicatorType: indicatorType,
          size: size,
          shape: shape,
          strokeWidth: strokeWidth,
          itemCount: itemCount,
          lineWidth: lineWidth,
          borderWidth: borderWidth,
          delay: delay,
          color: Colors.black);
}

/// loading style of [AnyLoadingLayer]
class AnyLoadingStyle {
  /// animationType
  final AnyLoadingAnimationType animationType;

  /// animation duration of indicator, default 200ms.
  final Duration animationDuration;

  /// display duration, default 2000ms.
  final Duration? displayDuration;

  /// content padding
  final EdgeInsets contentPadding;

  /// content decoration
  final Decoration? contentDecoration;

  /// content position
  final AlignmentGeometry position;

  /// only used for [AnyLoadingMaskType.custom]
  final Color? markColor;

  /// The titleTextStyle used for title.
  final TextStyle? titleTextStyle;

  /// The titleTextAlign used for title.
  final TextAlign? titleTextAlign;

  AnyLoadingStyle(
      {this.animationType = AnyLoadingAnimationType.opacity,
      this.animationDuration = const Duration(milliseconds: 200),
      this.displayDuration = const Duration(milliseconds: 2000),
      this.contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
      this.position = AlignmentDirectional.center,
      this.contentDecoration,
      this.titleTextStyle,
      this.titleTextAlign,
      this.markColor});

  factory AnyLoadingStyle.dark({
    AnyLoadingAnimationType animationType = AnyLoadingAnimationType.opacity,
    Duration animationDuration = const Duration(milliseconds: 200),
    Duration? displayDuration = const Duration(milliseconds: 2000),
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    ),
    TextAlign? titleTextAlign,
    AlignmentGeometry position = AlignmentDirectional.center,
  }) =>
      AnyLoadingStyle(
          animationType: animationType,
          animationDuration: animationDuration,
          displayDuration: displayDuration,
          contentPadding: contentPadding,
          position: position,
          titleTextStyle: const TextStyle(fontSize: 15.0, color: Colors.white),
          titleTextAlign: titleTextAlign ?? TextAlign.center,
          contentDecoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(5)));

  factory AnyLoadingStyle.light({
    AnyLoadingAnimationType animationType = AnyLoadingAnimationType.opacity,
    Duration animationDuration = const Duration(milliseconds: 200),
    Duration? displayDuration = const Duration(milliseconds: 2000),
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    ),
    TextAlign? titleTextAlign,
    AlignmentGeometry position = AlignmentDirectional.center,
  }) =>
      AnyLoadingStyle(
          animationType: animationType,
          animationDuration: animationDuration,
          displayDuration: displayDuration,
          contentPadding: contentPadding,
          position: position,
          titleTextStyle: const TextStyle(fontSize: 15.0, color: Colors.black),
          titleTextAlign: titleTextAlign ?? TextAlign.center,
          contentDecoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)));
}

const BoxConstraints _defaultAnyModalConstraints =
    BoxConstraints.expand(width: 320, height: 240);

class AnyModalStyle {
  /// Whether to show the cancel button, default true.
  final bool showCancel;

  /// cancel button string, default 'Cancel'.
  final String? cancelText;

  /// cancel button color.
  final Color? cancelColor;

  /// confirm button string, default 'Confirm'.
  final String confirmText;

  /// confirm button color.
  final Color? confirmColor;

  /// title text color.
  final Color? titleColor;

  /// content text color.
  final Color contentColor;

  /// constraints of dialog container, default width 320, height 240.
  final BoxConstraints constraints;

  AnyModalStyle({
    required this.showCancel,
    required this.confirmText,
    required this.contentColor,
    this.cancelText,
    this.cancelColor,
    this.confirmColor,
    this.titleColor,
    this.constraints = _defaultAnyModalConstraints,
  });

  factory AnyModalStyle.light(
          {bool showCancel = true,
          String? cancelText = 'Cancel',
          Color? cancelColor,
          String confirmText = 'Confirm',
          Color? confirmColor,
          BoxConstraints? constraints}) =>
      AnyModalStyle(
          showCancel: showCancel,
          cancelColor: cancelColor ?? Colors.black,
          confirmText: confirmText,
          cancelText: cancelText,
          contentColor: Colors.black,
          titleColor: Colors.black,
          constraints: constraints ?? _defaultAnyModalConstraints,
          confirmColor: confirmColor ?? Color(int.parse('0xff576B95')));

  factory AnyModalStyle.dark(
          {bool showCancel = true,
          String? cancelText = 'Cancel',
          Color? cancelColor,
          String confirmText = 'Confirm',
          Color? confirmColor,
          BoxConstraints? constraints}) =>
      AnyModalStyle(
          showCancel: showCancel,
          cancelColor: cancelColor ?? Colors.white70,
          confirmText: confirmText,
          cancelText: cancelText,
          contentColor: Colors.white,
          titleColor: Colors.white,
          constraints: constraints ?? _defaultAnyModalConstraints,
          confirmColor: confirmColor ?? Colors.white);
}

class AnyLoadingTheme {
  /// [AnyLoadingStyle]
  final AnyLoadingStyle style;

  /// [AnyLoadingMaskType]
  final AnyLoadingMaskType maskType;

  AnyLoadingTheme({
    required this.style,
    this.maskType = AnyLoadingMaskType.none,
  });
}
