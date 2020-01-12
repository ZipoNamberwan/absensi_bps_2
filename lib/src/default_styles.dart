import 'package:flutter/material.dart';

import 'color.dart';

const TextStyle defaultHeaderTextStyle = const TextStyle(
  fontSize: 14.0,
  color: Colors.blue,
);
const TextStyle defaultPrevDaysTextStyle = const TextStyle(
  color: Colors.grey,
  fontSize: 14.0,
);
const TextStyle defaultNextDaysTextStyle = const TextStyle(
  color: Colors.grey,
  fontSize: 14.0,
);
const TextStyle defaultDaysTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 14.0,
);
const TextStyle defaultTodayTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14.0,
);
const TextStyle defaultSelectedDayTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14.0,
);
const TextStyle defaultWeekdayTextStyle = const TextStyle(
  color: Colors.deepOrange,
  fontSize: 14.0,
);
const TextStyle defaultWeekendTextStyle = const TextStyle(
  color: Colors.pinkAccent,
  fontSize: 14.0,
);
const TextStyle defaultInactiveDaysTextStyle = const TextStyle(
  color: Colors.black38,
  fontSize: 14.0,
);
final TextStyle defaultInactiveWeekendTextStyle = TextStyle(
  color: Colors.pinkAccent.withOpacity(0.6),
  fontSize: 14.0,
);
final Widget defaultMarkedDateWidget = Container(
  margin: EdgeInsets.symmetric(horizontal: 1.0),
  color: Colors.blueAccent,
  height: 4.0,
  width: 4.0,
);

const TextStyle defaultEventTextStyle =
    const TextStyle(fontSize: 14, color: Colors.white);

const double defaultIconSize = 14.0;

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

final TextStyle loginHintTextStyle = TextStyle(fontSize: 13, color: Colors.grey);

Color splashColor = Colors.blue;

TextStyle userNameTextStyle = TextStyle(
    fontSize: 25,
    color: primaryTextColor,
    fontWeight: FontWeight.w500
);

TextStyle rankTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.bold
);

TextStyle hoursPlayedLabelTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle hoursPlayedTextStyle = TextStyle(
  fontSize: 28,
  color: secondaryTextColor,
  fontWeight: FontWeight.normal,
);

TextStyle headingOneTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

TextStyle headingTwoTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey.shade900,
  fontWeight: FontWeight.bold,
);

TextStyle bodyTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey.shade600,
);

TextStyle newGameTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w700
);

TextStyle newGameNameTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w700
);

TextStyle playWhiteTextStyle = TextStyle(
    fontSize: 14,
    color: firstColor,
    fontWeight: FontWeight.w700
);

