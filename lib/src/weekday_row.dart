import 'package:flutter/material.dart';
import 'package:absensi_bps_2/src/default_styles.dart'
    show WeekdayFormat, defaultWeekdayTextStyle;
import 'package:intl/intl.dart';

class WeekdayRow extends StatelessWidget {
  WeekdayRow(this.firstDayOfWeek,
      {@required this.showWeekdays,
      @required this.weekdayFormat,
      @required this.weekdayMargin,
      @required this.weekdayTextStyle,
      @required this.localeDate,
      @required this.weekdayRowHeight});

  final bool showWeekdays;
  final WeekdayFormat weekdayFormat;
  final EdgeInsets weekdayMargin;
  final TextStyle weekdayTextStyle;
  final DateFormat localeDate;
  final int firstDayOfWeek;
  final double weekdayRowHeight;

  Widget _weekdayContainer(String weekDay) => Expanded(
          child: Container(
        margin: weekdayMargin,
        child: Center(
          child: DefaultTextStyle(
            style: defaultWeekdayTextStyle,
            child: Text(
              weekDay,
              style: weekdayTextStyle,
            ),
          ),
        ),
      ));

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var i = firstDayOfWeek, count = 0;
        count < 7;
        i = (i + 1) % 7, count++) {
      String weekDay;

      switch (weekdayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = localeDate.dateSymbols.WEEKDAYS[i];
          break;
        case WeekdayFormat.standalone:
          weekDay = localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
        case WeekdayFormat.short:
          weekDay = localeDate.dateSymbols.SHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneShort:
          weekDay = localeDate.dateSymbols.STANDALONESHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.narrow:
          weekDay = localeDate.dateSymbols.NARROWWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneNarrow:
          weekDay = localeDate.dateSymbols.STANDALONENARROWWEEKDAYS[i];
          break;
        default:
          weekDay = localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
      }
      list.add(_weekdayContainer(weekDay));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) => showWeekdays
      ? Container(
          height: weekdayRowHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _renderWeekDays(),
          ),
        )
      : Container();
}
