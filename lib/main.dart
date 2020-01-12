library flutter_calendar_dooboo;

import 'package:absensi_bps_2/home.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:absensi_bps_2/calendar_carousel.dart' show CalendarCarousel;

import 'package:absensi_bps_2/classes/event_list.dart';
import 'package:absensi_bps_2/classes/detail_absensi.dart';
import 'classes/bidang.dart';
import 'classes/keterangan_absensi.dart';
import 'classes/shared_preference.dart';
import 'login/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: firstPrimaryColor
    ));*/
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi BPS Prov NTT',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class AbsensiPage extends StatefulWidget {
  AbsensiPage({Key key, this.bidang, this.pegawai}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Bidang bidang;
  final Pegawai pegawai;

  @override
  _AbsensiPageState createState() => new _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MapList<Pegawai> pegawaiList = new MapList();
  MapList<Status> statusList = new MapList();
  MapPegawaiEvent<DetailAbsensi> mapPegawaiEvent = new MapPegawaiEvent();
  MapPegawaiEvent<KeteranganAbsensi> mapKeteranganEvent = new MapPegawaiEvent();
  CalendarCarousel _calendarCarousel;

  @override
  initState() {
    /// Add more events to _markedDateMap EventList
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Example with custom icon

    _calendarCarousel = CalendarCarousel<DetailAbsensi>(
      thisMonthDayBorderColor: Colors.grey,
      prevMonthDayBorderColor: Colors.grey,
      nextMonthDayBorderColor: Colors.grey,
      daysHaveCircularBorder: false,
      staticSixWeekFormat: true,
      dayPadding: 0,
      iconSize: 20,
      headerTextStyle: TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
      daysTextStyle: TextStyle(color: Colors.black, fontSize: 11),
      weekendTextStyle: TextStyle(color: Colors.red[700], fontSize: 11),
      nextDaysTextStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
      prevDaysTextStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
      weekdayTextStyle: TextStyle(color: Colors.black, fontSize: 11),
      eventTextStyle: TextStyle(color: Colors.white, fontSize: 10),
      iconColor: Colors.black,
      weekFormat: false,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.bottom -
          MediaQuery.of(context).padding.top -
          kBottomNavigationBarHeight,
      width: MediaQuery.of(context).size.width,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      weekdayRowHeight: 40,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      todayTextStyle: TextStyle(
        color: Colors.blue,
        fontSize: 11,
        fontWeight: FontWeight.w900,
      ),
      todayBorderColor: Colors.grey,
      todayButtonColor: Colors.transparent,
      markedDateMoreShowTotal: false,
      pegawaiList: pegawaiList,
      statusList: statusList,
      mapPegawaiEvent: mapPegawaiEvent,
      mapKeteranganEvent: mapKeteranganEvent,
      bidang: widget.bidang != null ? widget.bidang : null,
      selectedPegawai: widget.pegawai != null ? widget.pegawai : null,
      onPressedDrawer: () {
        _scaffoldKey.currentState.openDrawer();
      },
      scaffoldKey: _scaffoldKey,
      pulangColor: secondColor,
      masukColor: firstColor,
      telatColor: thirdColor,
    );

    return _calendarCarousel;
  }
}
