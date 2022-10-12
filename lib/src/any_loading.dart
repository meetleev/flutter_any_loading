import 'dart:async';

import 'package:any_loading/src/any_loading_layer.dart';
import 'package:any_loading/src/theme.dart';
import 'package:any_loading/src/widgets/dialog.dart';
import 'package:flutter/material.dart';

import 'any_loading_animation.dart';
import 'widgets/indicator.dart';

class AnyLoading {
  static final AnyLoading _instance = AnyLoading._();

  factory AnyLoading() => _instance;
  AnyLoadingOverlayEntry? _overlayEntry;

  AnyLoadingOverlayEntry get overlayEntry => _overlayEntry!;

  Widget? _overlayEntryWidget;
  GlobalKey<AnyLoadingLayerState>? _anyLoadingLayerStateKey;
  Timer? _netLoadingIndicatorDelayTimer;

  AnyLoading._();

  /// enter point, used for builder of [MaterialApp] or [CupertinoApp]
  static TransitionBuilder init() {
    return (BuildContext context, Widget? child) {
      AnyLoading._instance._overlayEntry ??= AnyLoadingOverlayEntry(
          builder: (BuildContext context) =>
              AnyLoading._instance._overlayEntryWidget ?? Container());
      return Material(
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (BuildContext context) {
                if (child != null) {
                  return child;
                } else {
                  return Container();
                }
              },
            ),
            AnyLoading._instance.overlayEntry
          ],
        ),
      );
    };
  }

  /// showSuccess
  static Future<void> showSuccess(
    String msg, {
    Icon icon = AnyLoadingIndicatorStyle.defaultSuccessIcon,
    AnyLoadingStyle? style,
    AnyLoadingMaskType maskType = AnyLoadingMaskType.none,
  }) {
    style ??= AnyLoadingStyle.dark(position: AlignmentDirectional.center);
    return showToast(msg, icon: icon, style: style, maskType: maskType);
  }

  /// showError
  static Future<void> showError(
    String msg, {
    Icon icon = AnyLoadingIndicatorStyle.defaultErrorIcon,
    AnyLoadingStyle? style,
    AnyLoadingMaskType maskType = AnyLoadingMaskType.none,
  }) {
    style ??= AnyLoadingStyle.dark(position: AlignmentDirectional.center);
    return showToast(msg, icon: icon, style: style, maskType: maskType);
  }

  /// showToast
  static Future<void> showToast(
    String msg, {
    Icon? icon,
    AnyLoadingStyle? style,
    AnyLoadingMaskType maskType = AnyLoadingMaskType.none,
  }) {
    style ??= AnyLoadingStyle.dark(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        position: const AlignmentDirectional(0, 0.9));
    return _instance._show(
        indicator: icon,
        title: msg,
        loadingTheme: AnyLoadingTheme(
          style: style,
          maskType: maskType,
        ));
  }

  /// showLoading
  static Future<void> showLoading({
    String? title,
    Widget? indicator,
    AnyLoadingStyle? style,
    AnyLoadingMaskType maskType = AnyLoadingMaskType.none,
    AnyLoadingIndicatorStyle? indicatorStyle,
  }) {
    style ??= AnyLoadingStyle.dark();
    indicator ??= AnyLoadingIndicator(indicatorStyle: indicatorStyle);
    return _instance._show(
        loadingTheme: AnyLoadingTheme(style: style, maskType: maskType),
        title: title,
        indicator: indicator);
  }

  /// showNetLoading
  static Future<void> showNetLoading({
    String? title,
    AnyLoadingAnimationType animationType = AnyLoadingAnimationType.opacity,
    Duration animationDuration = const Duration(milliseconds: 200),
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    ),
    AlignmentGeometry position = AlignmentDirectional.center,
    Decoration? contentDecoration,
    Widget? indicator,
    Duration delayShowIndicatorDuration = const Duration(seconds: 5),
    AnyLoadingIndicatorStyle? indicatorStyle,
  }) async {
    AnyLoadingStyle loadingStyle = AnyLoadingStyle(
      displayDuration: null,
      animationType: animationType,
      animationDuration: animationDuration,
      contentPadding: contentPadding,
      position: position,
      titleTextStyle: const TextStyle(color: Colors.white),
      contentDecoration: contentDecoration ??
          BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(5)),
    );
    await showBlockInputLayer(
        style: loadingStyle, maskType: AnyLoadingMaskType.clear);
    _instance._cancelTimers();
    Completer completer = Completer();
    _instance._netLoadingIndicatorDelayTimer =
        Timer(delayShowIndicatorDuration, () {
      if (null != _instance._overlayEntryWidget) completer.complete();
    });
    return completer.future.whenComplete(() => showLoading(
        title: title,
        indicator: indicator,
        indicatorStyle: indicatorStyle,
        style: loadingStyle,
        maskType: AnyLoadingMaskType.black));
  }

  /// showModal
  static Future<void> showModal(
      {required String content,
      String? title,
      AnyLoadingStyle? style,
      ModelButtonOnTap? success,
      AnyModalStyle? anyModalStyle}) {
    style ??= AnyLoadingStyle.light(
        displayDuration: null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0));
    AnyLoadingTheme loadingTheme =
        AnyLoadingTheme(style: style, maskType: AnyLoadingMaskType.black);
    anyModalStyle ??= AnyModalStyle.light();
    Widget dialog = AnyModelDialog(
        title: title,
        content: content,
        anyModalStyle: anyModalStyle,
        success: (bool isSuccess) {
          dismiss();
          success?.call(isSuccess);
        });
    return _instance._show(
        loadingTheme: loadingTheme,
        customContentBuilder: (BuildContext context) {
          var sys = MediaQuery.of(context);
          return Container(
            decoration: style!.contentDecoration,
            padding: style.contentPadding,
            width: sys.size.width *
                (anyModalStyle!.dialogSizePercent?.width ?? 0.7),
            height: sys.size.height *
                (anyModalStyle.dialogSizePercent?.height ?? 0.6),
            child: dialog,
          );
        });
  }

  /// showBlockInputLayer
  static Future<void> showBlockInputLayer(
      {AnyLoadingStyle? style,
      AnyLoadingMaskType maskType = AnyLoadingMaskType.black}) {
    style ??= AnyLoadingStyle.dark();
    AnyLoadingTheme loadingTheme =
        AnyLoadingTheme(style: style, maskType: maskType);
    return _instance._show(loadingTheme: loadingTheme);
  }

  Future<void> _show(
      {required AnyLoadingTheme loadingTheme,
      String? title,
      Widget? indicator,
      Function(BuildContext context)? customContentBuilder}) async {
    if (null != _anyLoadingLayerStateKey) await dismiss();
    _anyLoadingLayerStateKey = GlobalKey<AnyLoadingLayerState>();
    Completer completer = Completer();
    _overlayEntryWidget = AnyLoadingLayer(
      key: _anyLoadingLayerStateKey,
      indicator: indicator,
      customContentBuilder: customContentBuilder,
      title: title,
      loadingTheme: loadingTheme,
      completer: completer,
    );
    overlayEntry.markNeedsBuild();
    return completer.future.whenComplete(() {
      if (null != loadingTheme.style.displayDuration) {
        Future.delayed(
            loadingTheme.style.displayDuration!, () async => await dismiss());
      }
    });
  }

  /// dismiss
  static Future<void> dismiss({bool animation = true}) {
    bool isActive = _instance._cancelTimers();
    if (isActive) animation = false;
    return _instance._dismiss(animation);
  }

  bool _cancelTimers() {
    bool? isActive = _netLoadingIndicatorDelayTimer?.isActive;
    _netLoadingIndicatorDelayTimer?.cancel();
    _netLoadingIndicatorDelayTimer = null;
    return isActive ?? false;
  }

  Future<void> _dismiss(bool animation) async {
    if (null != _anyLoadingLayerStateKey &&
        _anyLoadingLayerStateKey?.currentState == null) {
      _reset();
      return;
    }
    return _anyLoadingLayerStateKey?.currentState
        ?.dismiss(animation)
        .whenComplete(() => _reset());
  }

  void _reset() {
    _anyLoadingLayerStateKey = null;
    _overlayEntryWidget = null;
    overlayEntry.markNeedsBuild();
  }
}
