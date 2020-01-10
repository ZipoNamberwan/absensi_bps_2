import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';
import 'default_styles.dart' show defaultHeaderTextStyle, defaultIconSize;

class CalendarHeader extends StatelessWidget {
  /// Passing in values for [leftButtonIcon] or [rightButtonIcon] will override [headerIconColor]
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

  TextStyle get getTextStyle =>
      headerTextStyle != null ? headerTextStyle : defaultHeaderTextStyle;

  Widget _leftButton() => InkWell(
        child: IconButton(
          iconSize: this.iconSize != null ? this.iconSize : defaultIconSize,
          onPressed: onLeftButtonPressed,
          icon: leftButtonIcon ??
              Icon(Icons.chevron_left, color: headerIconColor),
        ),
        splashColor: splashColor,
        onTap: () {},
      );

  Widget _rightButton() => InkWell(
        child: IconButton(
          iconSize: this.iconSize != null ? this.iconSize : defaultIconSize,
          onPressed: onRightButtonPressed,
          icon: rightButtonIcon ??
              Icon(Icons.chevron_right, color: headerIconColor),
        ),
        splashColor: splashColor,
        onTap: () {},
      );

  Widget _headerTouchable() => FlatButton(
        onPressed: onHeaderTitlePressed,
        child: Text(headerTitle, style: getTextStyle),
      );

  @override
  Widget build(BuildContext context) => showHeader
      ? Center(
          child: Container(
            child: DefaultTextStyle(
                style: getTextStyle,
                child: Row(
                  children: <Widget>[
                    showHeaderButtons ? _leftButton() : Container(),
                    isTitleTouchable
                        ? _headerTouchable()
                        : Text(headerTitle, style: getTextStyle),
                    showHeaderButtons ? _rightButton() : Container()
                  ],
                )),
          ),
        )
      : Container();
}
