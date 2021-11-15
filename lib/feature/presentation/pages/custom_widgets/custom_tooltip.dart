//Usage
//wrap your icon or widget with KoalaTooltip and supply tooltipMessage
//  KoalaTooltip(
//    message: 'Input must be an Email Address',
//    child: Icon(
//    Icons.error,
//    color: Colors.red,
//          ),
//   )

import 'package:flutter/material.dart';

class ITooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const ITooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      decoration: const BoxDecoration(
        color: Color(0xff1b476f),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
