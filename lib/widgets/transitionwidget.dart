import 'package:flutter/cupertino.dart';

class TansitionWidget extends PageRouteBuilder {
  late final Widget widget;
  late Alignment alignment;

  TansitionWidget({required this.widget, required this.alignment})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutCirc);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: alignment,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) {
              return widget;
            });
}
