import 'package:any_loading/src/theme.dart';
import 'package:flutter/material.dart';

typedef ModelButtonOnTap = Function(bool isSuccess);

class AnyModelDialog extends StatelessWidget {
  final String content;
  final String? title;
  final AnyModalStyle anyModalStyle;
  final ModelButtonOnTap success;

  const AnyModelDialog(
      {super.key,
      required this.content,
      required this.anyModalStyle,
      required this.success,
      this.title});

  @override
  Widget build(BuildContext context) {
    var sys = MediaQuery.of(context);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: null != title
                ? Text(
              title!,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: anyModalStyle.titleColor),
            )
                : Container(),
          ),
          // SizedBox(height: constraints.minHeight * 0.6,
          //   child: Center(
          //     child: Text(
          //       content,
          //       style: TextStyle(color: anyModalStyle.titleColor),
          //     ),
          //   ),
          // ),
          Expanded(flex: 3,
            child: Center(
              child: Text(
                content,
                style: TextStyle(color: anyModalStyle.titleColor),
              ),
            ),
          ),
          const Divider(),
          anyModalStyle.showCancel
              ? Expanded(
              child: SizedBox(
                // height: 50,
                width: sys.size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => success.call(false),
                        child: Text(anyModalStyle.cancelText ?? 'Cancel',
                            style:
                            TextStyle(color: anyModalStyle.cancelColor))),
                    const VerticalDivider(),
                    TextButton(
                        onPressed: () => success.call(true),
                        child: Text(
                          anyModalStyle.confirmText,
                          style: TextStyle(color: anyModalStyle.confirmColor),
                        ))
                  ],
                ),
              ))
              : TextButton(
              onPressed: () => success.call(false),
              child: Text(anyModalStyle.confirmText,
                  style: TextStyle(color: anyModalStyle.confirmColor)))
        ],
      );
    },);
  }
}
