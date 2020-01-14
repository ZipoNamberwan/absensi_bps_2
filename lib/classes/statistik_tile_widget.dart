import 'package:absensi_bps_2/classes/progress_widget.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';

class StatistikTile extends StatefulWidget {
  final String title;
  final String subTitle;
  final double screenWidth;
  final int frequency;

  const StatistikTile(
      {Key key,
      this.title,
      this.subTitle,
      this.screenWidth,
      this.frequency,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatistikTileState();
}

class _StatistikTileState extends State<StatistikTile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var freq = widget.frequency;
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
              progress: _convertFreqToPercent(widget.frequency),
              screenWidth: widget.screenWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$freq',
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
