import 'dart:async';

import 'package:any_loading/src/any_loading_animation.dart';
import 'package:any_loading/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0
T? _ambiguate<T>(T? value) => value;

/// schedulePostFrame
void schedulePostFrame(Function callback) {
  SchedulerBinding? schedulerBinding = _ambiguate(SchedulerBinding.instance);
  if (SchedulerPhase.persistentCallbacks == schedulerBinding?.schedulerPhase) {
    schedulerBinding?.addPostFrameCallback((Duration duration) => callback());
  } else {
    callback();
  }
}

class AnyLoadingLayer extends StatefulWidget {
  ///  title used for [showSuccess] or [showError] or [showToast] or [showLoading] or [showNetLoading]
  final Widget? indicator;

  ///  content custom builder.
  final Function(BuildContext context)? customContentBuilder;

  ///  title used for [showSuccess] or [showError] or [showToast] or [showLoading] or [showNetLoading]
  final String? title;

  ///  [AnyLoadingTheme]
  final AnyLoadingTheme loadingTheme;

  ///  The completer used for animation playback complete event.
  final Completer? completer;

  const AnyLoadingLayer(
      {super.key,
      this.indicator,
      required this.loadingTheme,
      this.completer,
      this.title,
      this.customContentBuilder});

  @override
  State<StatefulWidget> createState() => AnyLoadingLayerState();
}

class AnyLoadingLayerState extends State<AnyLoadingLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  AnyLoadingTheme get _loadingTheme => widget.loadingTheme;

  Color get _markColor {
    switch (_loadingTheme.maskType) {
      case AnyLoadingMaskType.none:
      case AnyLoadingMaskType.clear:
        return Colors.transparent;
      case AnyLoadingMaskType.black:
        return Colors.black.withOpacity(0.5);
      case AnyLoadingMaskType.custom:
        assert(null != _loadingTheme.style.markColor, "markColor, null given!");
        return _loadingTheme.style.markColor!;
    }
  }

  bool get _ignoring =>
      AnyLoadingMaskType.none == _loadingTheme.maskType ? true : false;

  AlignmentGeometry get _alignment => _loadingTheme.style.position;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _loadingTheme.style.animationDuration,
    )..addStatusListener((status) {
        bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });
    show(true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: _alignment,
      children: [
        _buildMaskLayer(),
        if (null != widget.customContentBuilder ||
            null != widget.indicator ||
            null != widget.title && widget.title!.isNotEmpty)
          AnimatedBuilder(
            animation: _animationController,
            builder: _buildContent,
          )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildMaskLayer() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _animationController.value,
          child: IgnorePointer(
            ignoring: _ignoring,
            child: Container(
              color: _markColor,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }

  /// show
  Future<void> show(bool animation) {
    Completer completer = Completer();
    schedulePostFrame(() => completer
        .complete(_animationController.forward(from: animation ? 0 : 1)));
    return completer.future;
  }

  /// dismiss
  Future<void> dismiss(bool animation) {
    Completer completer = Completer();
    schedulePostFrame(() => completer
        .complete(_animationController.reverse(from: animation ? 1 : 0)));
    return completer.future;
  }

  Widget _buildContent(BuildContext context, Widget? child) {
    return _doContentAnimation(
        child: null != widget.customContentBuilder
            ? widget.customContentBuilder!(context)
            : _buildIndicator(context));
  }

  Widget _doContentAnimation(
      {required Widget child, AlignmentGeometry? alignment}) {
    return AnyLoadingAnimation(
      controller: _animationController,
      alignment: alignment,
      animationType: _loadingTheme.style.animationType,
      child: child,
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return Container(
      decoration: _loadingTheme.style.contentDecoration ??
          _buildDefaultContentDecoration(),
      padding: _loadingTheme.style.contentPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (null != widget.indicator)
            Container(
              margin: null != widget.title && widget.title!.isNotEmpty
                  ? const EdgeInsets.only(bottom: 10)
                  : EdgeInsets.zero,
              child: widget.indicator,
            ),
          if (null != widget.title && widget.title!.isNotEmpty)
            Text(
              widget.title!,
              style: _loadingTheme.style.titleTextStyle,
              textAlign: _loadingTheme.style.titleTextAlign,
            ),
        ],
      ),
    );
  }

  Decoration _buildDefaultContentDecoration() {
    return BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(5));
  }
}

/// AnyLoadingOverlayEntry
class AnyLoadingOverlayEntry extends OverlayEntry {
  AnyLoadingOverlayEntry({required super.builder});
  @override
  void markNeedsBuild() {
    schedulePostFrame(() => super.markNeedsBuild());
  }
}
