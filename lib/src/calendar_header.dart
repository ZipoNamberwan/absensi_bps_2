import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';
import 'default_styles.dart' show defaultHeaderTextStyle, defaultIconSize;

class CalendarHeader extends StatefulWidget {
  final String headerTitle;
  final EdgeInsetsGeometry headerMargin;
  final bool showHeader;
  final TextStyle headerTextStyle;
  final bool showHeaderButtons;
  final Color headerIconColor;
  final Widget leftButtonIcon;
  final Widget rightButtonIcon;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final bool isTitleTouchable;
  final VoidCallback onHeaderTitlePressed;
  final double iconSize;

  CalendarHeader({
    @required this.headerTitle,
    this.headerMargin,
    this.showHeader,
    this.headerTextStyle,
    this.showHeaderButtons,
    this.headerIconColor,
    this.leftButtonIcon,
    this.rightButtonIcon,
    @required this.onLeftButtonPressed,
    @required this.onRightButtonPressed,
    this.isTitleTouchable,
    @required this.onHeaderTitlePressed,
    this.iconSize,
  });

  @override
  State<StatefulWidget> createState() {
    return CalendarHeaderState();
  }
}

class CalendarHeaderState extends State<CalendarHeader>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle getTextStyle = widget.headerTextStyle != null
        ? widget.headerTextStyle
        : defaultHeaderTextStyle;

    Widget _leftButton() => InkWell(
          child: IconButton(
            iconSize:
                widget.iconSize != null ? widget.iconSize : defaultIconSize,
            onPressed: widget.onLeftButtonPressed,
            icon: widget.leftButtonIcon ??
                Icon(Icons.chevron_left, color: widget.headerIconColor),
          ),
          splashColor: splashColor,
          onTap: () {},
        );

    Widget _rightButton() => IconButton(
          iconSize: widget.iconSize != null ? widget.iconSize : defaultIconSize,
          onPressed: widget.onRightButtonPressed,
          icon: widget.rightButtonIcon ??
              Icon(Icons.chevron_right, color: widget.headerIconColor),
        );

    Widget _headerTouchable() => FlatButton(
          onPressed: widget.onHeaderTitlePressed,
          child: Text(widget.headerTitle, style: getTextStyle),
        );

    return widget.showHeader
        ? Center(
            child: Container(
              child: DefaultTextStyle(
                  style: getTextStyle,
                  child: Row(
                    children: <Widget>[
                      widget.showHeaderButtons ? _leftButton() : Container(),
                      widget.isTitleTouchable
                          ? _headerTouchable()
                          : Text(widget.headerTitle, style: getTextStyle),
                      widget.showHeaderButtons ? _rightButton() : Container()
                    ],
                  )),
            ),
          )
        : Container();
  }
}
