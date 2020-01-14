import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  final double progress, screenWidth;

  const ProgressWidget({Key key, this.progress, this.screenWidth}) : super(key: key);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> progressAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    progressAnimation = Tween<double>(begin: 0, end: widget.screenWidth * 0.33 * widget.progress).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.screenWidth * 0.33;

    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (context, widget) {
        return Stack(
          children: <Widget>[
            Container(
              width: width,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: tertiaryTextColor, width: 1),
              ),
            ),
            Container(
              width: progressAnimation.value,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  gradient: appGradient
              ),
            ),
          ],
        );
      },
    );
  }
}