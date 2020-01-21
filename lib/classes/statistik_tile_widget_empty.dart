import 'package:absensi_bps_2/classes/progress_widget.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';

class StatistikTileEmpty extends StatefulWidget {
  final String title;
  final String subTitle;
  final double screenWidth;

  const StatistikTileEmpty(
      {Key key,
        this.title,
        this.subTitle,
        this.screenWidth,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatistikTileEmptyState();
}

class _StatistikTileEmptyState extends State<StatistikTileEmpty>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: widget.title, style: headingTwoTextStyle),
                  TextSpan(text: '\n'),
                  TextSpan(text: widget.subTitle, style: bodyTextStyle),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ProgressWidget(
              progress: _convertFreqToPercent(0),
              screenWidth: widget.screenWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '0',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset.fromDirection(2, 2))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _convertFreqToPercent(int frequency) {
    return frequency / 10;
  }
}
