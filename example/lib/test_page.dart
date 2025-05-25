import 'dart:math';

import 'package:any_loading/any_loading.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

enum _Action { netLoading, loading, toast, iconToast, model }

extension on _Action {
  get title => [
        "ShowNetLoading",
        'ShowLoading',
        'ShowToast',
        'ShowToastWithIcon',
        'ShowModal'
      ][index];
}

class _TestPageState extends State<TestPage> {
  late int _curPageIdx = 0;
  late _Action _action = _Action.netLoading;
  late Size _screenSize;
  late PageController _controller;
  late GroupButtonController _maskTypeGBController,
      _delayShowIndicatorGBController,
      _positionGBController;
  final List<int> _delayShowIndicatorSeconds = [3, 5, 7];

  final List<String> _positionStrings = ['Top', 'Center', 'Bottom', 'Custom'];

  AlignmentGeometry get _position {
    int idx = _positionGBController.selectedIndex ?? 0;
    if (_positionStrings.length - 1 == idx) {
      return const AlignmentDirectional(0, 0.9);
    }
    return [
      AlignmentDirectional.topCenter,
      AlignmentDirectional.center,
      AlignmentDirectional.bottomCenter
    ][idx];
  }

  get _delayShowIndicatorSecond => _delayShowIndicatorSeconds
      .elementAt(_delayShowIndicatorGBController.selectedIndex ?? 0);
  final List<String> _maskTypeStrings = ['none', 'clear', 'black', 'Custom'];

  AnyLoadingMaskType get _maskType =>
      AnyLoadingMaskType.values[_maskTypeGBController.selectedIndex ?? 0];
  final List<String> _indicatorStrings = [
    'Wave',
    'RotatingPlain',
    'DoubleBounce',
    'WanderingCubes',
    'FadingFour',
    'FadingCube',
    'Pulse',
    'ChasingDots',
    'ThreeBounce',
    'Circle',
    'CubeGrid',
    'FadingCircle',
    'RotatingCircle',
    'FoldingCube',
    'PumpingHeart',
    'HourGlass',
    'PouringHourGlass',
    'PouringHourGlassRefined',
    'FadingGrid',
    'Ring',
    'Ripple',
    'SpinningCircle',
    'SpinningLines',
    'SquareCircle',
    'DualRing',
    'PianoWave',
    'DancingSquare',
    'ThreeInOut',
    'WaveSpinner',
    'PulsingGrid'
  ];

  AnyLoadingIndicatorType _indicatorStyle = AnyLoadingIndicatorType.circle;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _curPageIdx);
    _maskTypeGBController = GroupButtonController(selectedIndex: 0);
    _delayShowIndicatorGBController = GroupButtonController(selectedIndex: 0);
    _positionGBController = GroupButtonController(selectedIndex: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var sys = MediaQuery.of(context);
    _screenSize = sys.size;
  }

  @override
  void dispose() {
    _controller.dispose();
    _maskTypeGBController.dispose();
    _delayShowIndicatorGBController.dispose();
    _positionGBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sys = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_action.title),
      ),
      body: Stack(children: [
        PageView.builder(
          controller: _controller,
          itemBuilder: _buildPageItem,
          itemCount: _Action.values.length,
          onPageChanged: (int idx) => setState(() {
            _curPageIdx = idx;
            _action = _Action.values[idx];
          }),
        ),
        if (0 < _curPageIdx)
          Positioned(
              left: 5,
              bottom: sys.size.height * 0.5,
              child: TextButton(
                onPressed: () {
                  if (0 < _curPageIdx) {
                    _curPageIdx--;
                    _controller.jumpToPage(_curPageIdx);
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.navigate_before,
                  size: 40,
                ),
              )),
        if (_Action.values.length - 1 > _curPageIdx)
          Positioned(
              right: 5,
              bottom: sys.size.height * 0.5,
              child: TextButton(
                onPressed: () {
                  if (_Action.values.length - 1 > _curPageIdx) {
                    _curPageIdx++;
                    _controller.jumpToPage(_curPageIdx);
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.navigate_next,
                  size: 40,
                ),
              ))
      ]),
    );
  }

  Widget _buildPageItem(BuildContext context, int index) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: _onPressedShow, child: const Text('Show')),
            const SizedBox(
              width: 5,
            ),
            TextButton(
                onPressed: () => AnyLoading.dismiss(),
                child: const Text('Dismiss'))
          ],
        ),
        if (_Action.netLoading == _action && _Action.model != _action)
          _buildNetLoadingDelayShowDurations(),
        if (_Action.netLoading != _action && _Action.model != _action)
          _buildMaskTypes(),
        if (_Action.model != _action) _buildPositions(),
        if (_Action.toast != _action &&
            _Action.iconToast != _action &&
            _Action.model != _action)
          _buildIndicators(),
      ],
    );
  }

  Widget _buildPositions() {
    return Column(
      children: [
        const Divider(),
        const Center(
          child: Text('Position'),
        ),
        const SizedBox(
          height: 8,
        ),
        GroupButton(
          controller: _positionGBController,
          options: const GroupButtonOptions(spacing: 0),
          buttons: _positionStrings,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildMaskTypes() {
    return Column(
      children: [
        const Divider(),
        const Center(
          child: Text('MaskType'),
        ),
        const SizedBox(
          height: 8,
        ),
        GroupButton(
          controller: _maskTypeGBController,
          options: const GroupButtonOptions(spacing: 0),
          buttons: _maskTypeStrings,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildNetLoadingDelayShowDurations() {
    return Column(
      children: [
        const Divider(),
        const Center(
          child: Text('ShowIndicator DelayDuration'),
        ),
        const SizedBox(
          height: 8,
        ),
        GroupButton(
          controller: _delayShowIndicatorGBController,
          options: const GroupButtonOptions(spacing: 0),
          buttons: _delayShowIndicatorSeconds,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildIndicators() {
    return SizedBox(
      width: _screenSize.width * 0.6,
      child: Column(children: [
        const Divider(),
        Center(
          child: Text('IndicatorType (total ${_indicatorStrings.length})'),
        ),
        const SizedBox(
          height: 8,
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
              labelText: 'IndicatorType', border: OutlineInputBorder()),
          items: _indicatorStrings
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (String? value) {
            int idx = _indicatorStrings.indexOf(value!);
            _indicatorStyle = AnyLoadingIndicatorType.values[idx];
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  void _onPressedShow() {
    switch (_action) {
      case _Action.netLoading:
        AnyLoading.showNetLoading(
          title: 'Loading',
          position: _position,
          delayShowIndicatorDuration:
              Duration(seconds: _delayShowIndicatorSecond),
          indicatorStyle:
              AnyLoadingIndicatorStyle(indicatorType: _indicatorStyle),
        ).whenComplete(() => Future.delayed(
            const Duration(seconds: 10), () => AnyLoading.dismiss()));
        break;
      case _Action.loading:
        AnyLoading.showLoading(
            maskType: _maskType,
            style: AnyLoadingMaskType.custom == _maskType
                ? AnyLoadingStyle(
                    markColor: Colors.blue.withValues(alpha:  0.5),
                    contentDecoration: BoxDecoration(
                        color: [
                          Colors.red,
                          Colors.black,
                          Colors.green,
                          Colors.yellow
                        ][Random().nextInt(4)]
                            .withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(5)))
                : AnyLoadingStyle.dark(position: _position),
            indicatorStyle:
                AnyLoadingIndicatorStyle(indicatorType: _indicatorStyle));
        break;
      case _Action.toast:
        AnyLoading.showToast('Hello Flutter.',
            maskType: _maskType,
            style: AnyLoadingMaskType.custom == _maskType
                ? AnyLoadingStyle(
                    markColor: Colors.blue.withValues(alpha: .5),
                    contentDecoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(5)))
                : AnyLoadingStyle.dark(
                    position: _position,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    )));
        break;
      case _Action.iconToast:
        AnyLoading.showToast('Hello Flutter.',
            icon: AnyLoadingIndicatorStyle.defaultErrorIcon,
            maskType: _maskType,
            style: AnyLoadingMaskType.custom == _maskType
                ? AnyLoadingStyle(
                    markColor: Colors.blue.withValues(alpha: .5),
                    contentDecoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(5)))
                : AnyLoadingStyle.dark(
                    position: _position,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    )));
        break;
      case _Action.model:
        AnyLoading.showModal(
            title: 'title',
            content: 'content',
            success: (bool isSuccess) => debugPrint('isSuccess---$isSuccess'));
        break;
    }
  }
}
