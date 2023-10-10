import 'package:any_loading/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnyLoadingIndicator extends StatelessWidget {
  final AnyLoadingIndicatorStyle? indicatorStyle;

  const AnyLoadingIndicator({super.key, this.indicatorStyle});

  @override
  Widget build(BuildContext context) {
    return _buildLoadingIndicator(
        indicatorStyle ?? AnyLoadingIndicatorStyle.dark());
  }

  Widget _buildLoadingIndicator(AnyLoadingIndicatorStyle indicatorStyle) {
    Widget indicator;
    double size = indicatorStyle.size;
    double width = size;
    AnyLoadingIndicatorType indicatorType = indicatorStyle.indicatorType;
    Color color = indicatorStyle.color ?? Colors.white;
    switch (indicatorType) {
      case AnyLoadingIndicatorType.circle:
        indicator = SpinKitCircle(
          color: color,
          size: size,
        );
        break;
      case AnyLoadingIndicatorType.cubeGrid:
        indicator = SpinKitCubeGrid(
          color: color,
          size: size,
        );
        break;
      case AnyLoadingIndicatorType.fadingCircle:
        indicator = SpinKitFadingCircle(
          color: color,
          size: size,
        );
        break;
      case AnyLoadingIndicatorType.wave:
        indicator = SpinKitWave(
          color: color,
          size: size,
          itemCount: indicatorStyle.itemCount ?? 6,
        );
        width = size * 1.25;
        break;
      case AnyLoadingIndicatorType.threeBounce:
        indicator = SpinKitThreeBounce(color: color, size: size);
        width = size * 2;
        break;
      case AnyLoadingIndicatorType.rotatingPlain:
        indicator = SpinKitRotatingPlain(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.doubleBounce:
        indicator = SpinKitDoubleBounce(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.wanderingCubes:
        indicator = SpinKitWanderingCubes(
            color: color,
            size: size,
            shape: indicatorStyle.shape ?? BoxShape.rectangle);
        break;
      case AnyLoadingIndicatorType.fadingFour:
        indicator = SpinKitFadingFour(
            color: color,
            size: size,
            shape: indicatorStyle.shape ?? BoxShape.circle);
        break;
      case AnyLoadingIndicatorType.fadingCube:
        indicator = SpinKitFadingCube(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.pulse:
        indicator = SpinKitPulse(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.chasingDots:
        indicator = SpinKitChasingDots(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.rotatingCircle:
        indicator = SpinKitRotatingCircle(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.foldingCube:
        indicator = SpinKitFoldingCube(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.pumpingHeart:
        indicator = SpinKitPumpingHeart(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.hourGlass:
        indicator = SpinKitHourGlass(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.pouringHourGlass:
        indicator = SpinKitPouringHourGlass(
            color: color, size: size, strokeWidth: indicatorStyle.strokeWidth);
        break;
      case AnyLoadingIndicatorType.pouringHourGlassRefined:
        indicator = SpinKitPouringHourGlassRefined(
            color: color, size: size, strokeWidth: indicatorStyle.strokeWidth);
        break;
      case AnyLoadingIndicatorType.fadingGrid:
        indicator = SpinKitFadingGrid(
          color: color,
          size: size,
          shape: indicatorStyle.shape ?? BoxShape.circle,
        );
        break;
      case AnyLoadingIndicatorType.ring:
        indicator = SpinKitRing(
          color: color,
          size: size,
          lineWidth: indicatorStyle.lineWidth ?? 7,
        );
        break;
      case AnyLoadingIndicatorType.ripple:
        indicator = SpinKitRipple(
          color: color,
          size: size,
          borderWidth: indicatorStyle.borderWidth ?? 6,
        );
        break;
      case AnyLoadingIndicatorType.spinningCircle:
        indicator = SpinKitSpinningCircle(
          color: color,
          size: size,
          shape: indicatorStyle.shape ?? BoxShape.circle,
        );
        break;
      case AnyLoadingIndicatorType.spinningLines:
        indicator = SpinKitSpinningLines(
          color: color,
          size: size,
          itemCount: indicatorStyle.itemCount ?? 5,
          lineWidth: indicatorStyle.lineWidth ?? 2,
        );
        break;
      case AnyLoadingIndicatorType.squareCircle:
        indicator = SpinKitSquareCircle(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.dualRing:
        indicator = SpinKitDualRing(
          color: color,
          size: size,
          lineWidth: indicatorStyle.lineWidth ?? 7,
        );
        break;
      case AnyLoadingIndicatorType.pianoWave:
        indicator = SpinKitPianoWave(
          color: color,
          size: size,
          itemCount: indicatorStyle.itemCount ?? 5,
        ); // SpinKitPianoWaveType
        break;
      case AnyLoadingIndicatorType.dancingSquare:
        indicator = SpinKitDancingSquare(color: color, size: size);
        break;
      case AnyLoadingIndicatorType.threeInOut:
        indicator = SpinKitThreeInOut(
            color: color,
            size: size,
            delay: indicatorStyle.delay ?? const Duration(milliseconds: 50));
        width = size * 2;
        break;
      case AnyLoadingIndicatorType.waveSpinner:
        indicator = SpinKitWaveSpinner(
            color: color,
            size: size,
            trackColor: indicatorStyle.trackColor ?? const Color(0x68757575),
            waveColor: indicatorStyle.waveColor ?? const Color(0x68757575));
        break;
      case AnyLoadingIndicatorType.pulsingGrid:
        indicator = SpinKitPulsingGrid(
          color: color,
          size: size,
          boxShape: indicatorStyle.shape ?? BoxShape.circle,
        );
        break;
    }
    return SizedBox(
      width: width,
      child: indicator,
    );
  }
}
