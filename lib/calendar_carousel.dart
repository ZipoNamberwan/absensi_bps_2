import 'dart:async';
import 'dart:math';

import 'package:absensi_bps_2/classes/bidang.dart';
import 'package:absensi_bps_2/classes/custom_bottom_nav_bar.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/entri_kegiatan_page.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bps_2/classes/event_list.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:absensi_bps_2/src/calendar_header.dart';
import 'package:absensi_bps_2/src/weekday_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
export 'package:absensi_bps_2/classes/event_list.dart';
import 'package:absensi_bps_2/classes/detail_absensi.dart';
import 'package:absensi_bps_2/api/api_tad_absensi.dart';
import 'package:absensi_bps_2/api/api_custom.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'classes/keterangan_absensi.dart';
import 'classes/shared_preference.dart';
import 'classes/statistik.dart';
import 'detail_absensi_page.dart';
import 'home.dart';
import 'login/login.dart';

class CalendarCarousel<T> extends StatefulWidget {
  final double viewportFraction;
  final TextStyle prevDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime selectedDateTime;
  final TextStyle selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool daysHaveCircularBorder;
  final TextStyle weekdayTextStyle;
  final double weekdayRowHeight;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Widget headerText;
  final double headerHeight;
  final TextStyle weekendTextStyle;
  final List<DateTime> markedDates;
  final Color markedDateColor;
  final Widget markedDateWidget;
  final bool markedDateShowIcon;
  final Color markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final bool markedDateMoreShowTotal;
  final Decoration markedDateMoreCustomDecoration;
  final TextStyle markedDateMoreCustomTextStyle;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final bool weekFormat;
  final bool showWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final Widget leftButtonIcon;
  final Widget rightButtonIcon;
  final ScrollPhysics customGridViewPhysics;
  final Function(DateTime) onCalendarChanged;
  final String locale;
  final int firstDayOfWeek;
  final DateTime minSelectedDate;
  final DateTime maxSelectedDate;
  final TextStyle inactiveDaysTextStyle;
  final TextStyle inactiveWeekendTextStyle;
  final bool headerTitleTouchable;
  final Function onHeaderTitlePressed;
  final WeekdayFormat weekDayFormat;
  final bool staticSixWeekFormat;
  final bool isScrollable;
  final bool showOnlyCurrentMonthDate;
  final TextStyle eventTextStyle;
  final double iconSize;
  final MapList<Pegawai> pegawaiList;
  final MapList<Status> statusList;
  final Pegawai selectedPegawai;
  final MapPegawaiEvent<DetailAbsensi> mapPegawaiEvent;
  final MapPegawaiEvent<KeteranganAbsensi> mapKeteranganEvent;
  final Bidang bidang;
  final Function onPressedDrawer;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color telatColor;
  final Color masukColor;
  final Color pulangColor;
  final Color navItemColorActive;
  final Color navItemColorInactive;

  CalendarCarousel({
    this.viewportFraction = 1.0,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.red,
    this.todayButtonColor = Colors.red,
    this.selectedDateTime,
    this.selectedDayTextStyle,
    this.selectedDayBorderColor = Colors.green,
    this.selectedDayButtonColor = Colors.green,
    this.daysHaveCircularBorder,
    this.weekdayTextStyle,
    this.weekdayRowHeight = 30,
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerText,
    this.headerHeight = kToolbarHeight,
    this.weekendTextStyle,
    this.markedDates,
    this.markedDateColor,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5.0,
    this.markedDateIconOffset = 5.0,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateMoreCustomTextStyle,
    this.markedDateWidget,
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.showWeekDays = true,
    this.weekFormat = false,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = "id",
    this.firstDayOfWeek,
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDaysTextStyle,
    this.inactiveWeekendTextStyle,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.weekDayFormat = WeekdayFormat.short,
    this.staticSixWeekFormat = false,
    this.isScrollable = true,
    this.showOnlyCurrentMonthDate = false,
    this.eventTextStyle,
    this.iconSize,
    this.pegawaiList,
    this.statusList,
    this.selectedPegawai,
    this.mapPegawaiEvent,
    this.mapKeteranganEvent,
    this.bidang,
    this.onPressedDrawer,
    this.scaffoldKey,
    @required this.telatColor,
    @required this.masukColor,
    @required this.pulangColor,
    this.navItemColorActive = secondColor,
    this.navItemColorInactive = Colors.grey,
  });

  @override
  _CalendarState<T> createState() => _CalendarState<T>();
}

class _CalendarState<T> extends State<CalendarCarousel<T>>
    with TickerProviderStateMixin {
  static final int homePageIndex = 0;
  static final int calendarPageIndex = 1;
  static final int unduhPageIndex = 2;
  static final int fab1Clicked = 1;
  static final int fab2Clicked = 2;

  PageController _controller;
  List<DateTime> _dates = List(3);
  List<List<DateTime>> _weeks = List(3);
  DateTime _selectedDate = DateTime.now();
  int _startWeekday = 0;
  int _endWeekday = 0;
  String _selectedPegawai;
  DateFormat _localeDate;
  MapEvent<DetailAbsensi> _mapAbsensi = new MapEvent();
  MapEvent<KeteranganAbsensi> _mapKeterangan = new MapEvent();
  AnimationController _animationEventController;
  AnimationController _animationKeteranganController;
  AnimationController _animationAfterPostController;
  AnimationController _fabAnimationController;
  AnimationController _fabClickedAnimationController;
  Animation<double> _animationAbsensiEvent;
  Animation<double> _animationKeterangan;
  Animation<double> _animationAfterPost;
  Animation<double> _fabRotate;
  Animation<double> _fabBackgroundAnimation;
  Animation<Offset> _translateFabAnimation1;
  Animation<Offset> _translateFabAnimation2;
  Animation<double> _scaleFabAnimation;
  Animation<double> _fadeFabAnimation;
  Animation<double> _fadeFabTextAnimation;
  Animation<double> _fadeEverythingWhenFab1Clicked;
  Animation<Offset> _translateNavyBar;
  bool _isDetailLoading = true;
  bool _isListPegawaiLoading = true;
  bool _isKeteranganLoading = true;
  MapEvent<bool> _mapDatetimeAfterPost = new MapEvent();
  int _currentIndex = 0;
  Widget _currentPage;
  AnimationController _fadePageAnimationController;
  Animation<double> _fadePageAnimation;
  bool _fabOptionIsOpen = false;
  int _fabClicked = -1;

  UnduhBloc _unduhBloc = UnduhBloc();

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class
  bool _isReloadSelectedDate = true;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);

    initializeDateFormatting();

    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );

    _localeDate = DateFormat.yMMM(widget.locale);

    if (widget.firstDayOfWeek == null)
      firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    else
      firstDayOfWeek = widget.firstDayOfWeek;

    if (widget.selectedDateTime != null)
      _selectedDate = widget.selectedDateTime;

    _animationKeteranganController = _animationEventController =
        AnimationController(
            duration: const Duration(milliseconds: 500), vsync: this);

    _animationAfterPostController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fabAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    _fabClickedAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    _fabRotate = Tween<double>(begin: 0.0, end: -3 * pi / 4).animate(
        CurvedAnimation(
            parent: _fabAnimationController, curve: Curves.elasticOut));

    _translateFabAnimation1 =
        Tween<Offset>(begin: Offset.zero, end: Offset(-50, -50)).animate(
            CurvedAnimation(
                parent: _fabAnimationController,
                curve: Interval(0.0, 1.0, curve: Curves.elasticOut)));

    _translateFabAnimation2 =
        Tween<Offset>(begin: Offset.zero, end: Offset(50, -50)).animate(
            CurvedAnimation(
                parent: _fabAnimationController,
                curve: Interval(0.0, 1.0, curve: Curves.elasticOut)));

    _fadeFabAnimation = CurvedAnimation(
        parent: _fabAnimationController,
        curve: Interval(0.0, 0.1, curve: Curves.ease));

    _scaleFabAnimation = Tween<double>(begin: 40, end: 56).animate(
        CurvedAnimation(
            parent: _fabAnimationController,
            curve: Interval(0.0, 0.8, curve: Curves.elasticOut)));

    _fadeFabTextAnimation = CurvedAnimation(
        parent: _fabAnimationController,
        curve: Interval(0.5, 0.8, curve: Curves.ease));

    _fadeEverythingWhenFab1Clicked = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: _fabClickedAnimationController, curve: Curves.ease));

    _translateNavyBar = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight + 20))
        .animate(CurvedAnimation(
            parent: _fabAnimationController,
            curve: Interval(0.0, 1.0, curve: Curves.ease)));

    _fabBackgroundAnimation = Tween<double>(begin: 0, end: widget.height + 50)
        .animate(CurvedAnimation(
            parent: _fabAnimationController, curve: Curves.easeOut));

    _animationAbsensiEvent = CurvedAnimation(
        parent: _animationEventController, curve: Curves.easeIn);

    _animationKeterangan = CurvedAnimation(
        parent: _animationKeteranganController, curve: Curves.easeIn);

    _animationAfterPost = CurvedAnimation(
        parent: _animationAfterPostController, curve: Curves.easeOut);

    _fadePageAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _fadePageAnimation = Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(
            parent: _fadePageAnimationController, curve: Curves.easeIn));

    _fadePageAnimationController.forward().orCancel;

    _setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    _animationAfterPostController.dispose();
    _animationEventController.dispose();
    _animationKeteranganController.dispose();
    _fadePageAnimationController.dispose();
    _fabAnimationController.dispose();
    _fabClickedAnimationController.dispose();
    _unduhBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReloadSelectedDate) {
      if (widget.selectedDateTime != null)
        _selectedDate = widget.selectedDateTime;
      _setDatesAndWeeks();
    } else {
      _isReloadSelectedDate = true;
    }

    Widget calendarPage = Container(
      width: widget.width,
      height: widget.height - 5,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: widget.headerHeight,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      widget.bidang != null
                          ? IconButton(
                              icon: Icon(Icons.dehaze),
                              iconSize: widget.iconSize,
                              onPressed: widget.onPressedDrawer)
                          : Container(),
                      widget.bidang != null
                          ? Expanded(
                              child: Container(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  items: widget.pegawaiList.maps != null
                                      ? _createDropdownItems()
                                      : [],
                                  onChanged: (value) {
                                    setState(() {
                                      _isReloadSelectedDate = false;
                                      _selectedPegawai = value;
                                      _onPegawaiChanged();
                                    });
                                  },
                                  isDense: true,
                                  value: _selectedPegawai != null
                                      ? _selectedPegawai
                                      : null,
                                ),
                                margin: EdgeInsets.only(left: 15),
                              ),
                              flex: 2,
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Container(
                                  child: Text(
                                    widget.selectedPegawai.nama,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: widget.headerTextStyle,
                                  ),
                                ),
                              ),
                              flex: 2,
                            ),
                      CalendarHeader(
                        showHeader: widget.showHeader,
                        headerTitle: widget.weekFormat
                            ? '${_localeDate.format(_weeks[1].first)}'
                            : '${_localeDate.format(this._dates[1])}',
                        headerTextStyle: widget.headerTextStyle,
                        showHeaderButtons: widget.showHeaderButton,
                        headerIconColor: widget.iconColor,
                        leftButtonIcon: widget.leftButtonIcon,
                        rightButtonIcon: widget.rightButtonIcon,
                        onLeftButtonPressed: () => _setDate(0),
                        onRightButtonPressed: () => _setDate(2),
                        isTitleTouchable: widget.headerTitleTouchable,
                        onHeaderTitlePressed:
                            widget.onHeaderTitlePressed != null
                                ? widget.onHeaderTitlePressed
                                : () => _selectDateFromPicker(),
                        iconSize: widget.iconSize,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          WeekdayRow(
            firstDayOfWeek,
            showWeekdays: widget.showWeekDays,
            weekdayFormat: widget.weekDayFormat,
            weekdayMargin: widget.weekDayMargin,
            weekdayTextStyle: widget.weekdayTextStyle,
            localeDate: _localeDate,
            weekdayRowHeight: widget.weekdayRowHeight,
          ),
          Expanded(
              child: PageView.builder(
            itemCount: 3,
            dragStartBehavior: DragStartBehavior.down,
            physics: widget.isScrollable
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              this._setDate(index);
            },
            controller: _controller,
            itemBuilder: (context, index) {
              return builder(index);
            },
            pageSnapping: true,
          )),
        ],
      ),
    );

    Widget homePage;

    Widget ckpPage = Container();

    if (widget.bidang == null) {
      homePage = HomePage(
        pegawai: widget.selectedPegawai,
        stat: _generateStatistik(DateTime.now()),
        height: widget.height,
        details: _getAbsensiToday(DateTime.now()),
        headerTextStyle: widget.headerTextStyle,
        onPressedDrawer: widget.onPressedDrawer,
      );

      Widget unduhPage = BlocConsumer<UnduhBloc, UnduhState>(
        listener: (context, state) {
          if (state is SuccessState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Success",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      "File ada di folder download. Nama file: " +
                          state.result['filename'],
                      style: TextStyle(color: Colors.black54),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK")),
                    ],
                  );
                },
                barrierDismissible: true);
            _showNotification(state.result);
          } else if (state is ErrorState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Error",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      state.message,
                      style: TextStyle(color: Colors.black54),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK")),
                    ],
                  );
                },
                barrierDismissible: true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: kBottomNavigationBarHeight,
                      margin: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Unduh Laporan Harian",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 2, child: Text("Dari: ")),
                              Expanded(
                                flex: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2019, 1, 1),
                                        currentTime: state.from,
                                        onConfirm: (date) {
                                      _unduhBloc.add(ChangeFromDate(date));
                                    }, locale: LocaleType.id);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black12, width: 0.5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: state.from != null
                                              ? DateFormat("yyyy-MM-dd")
                                                  .format(state.from)
                                              : ""),
                                      decoration: InputDecoration(
                                          enabled: false,
                                          border: InputBorder.none,
                                          hintText: "dd/mm/yyyy",
                                          hintStyle: TextStyle(fontSize: 12),
                                          suffixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.black54,
                                            size: 23,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 2, child: Text("Sampai: ")),
                              Expanded(
                                flex: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2019, 1, 1),
                                        onConfirm: (date) {
                                      _unduhBloc.add(ChangeToDate(date));
                                    },
                                        currentTime: state.to,
                                        locale: LocaleType.id);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black12, width: 0.5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: state.to != null
                                              ? DateFormat("yyyy-MM-dd")
                                                  .format(state.to)
                                              : ""),
                                      decoration: InputDecoration(
                                          enabled: false,
                                          border: InputBorder.none,
                                          hintText: "dd/mm/yyyy",
                                          hintStyle: TextStyle(fontSize: 12),
                                          suffixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.black54,
                                            size: 23,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: state.isValid()
                          ? () async {
                              //download here
                              final isPermissionStatusGranted =
                                  await _requestPermissions();
                              if (isPermissionStatusGranted) {
                                _unduhBloc.add(
                                    StartDownload(widget.selectedPegawai.nip));
                              }
                            }
                          : () {},
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "UNDUH",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: state.isValid() ? 0.0 : 0.5,
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.white,
                            ),
                            duration: Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              state is LoadingState
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      );

      if (_currentIndex == homePageIndex) {
        _currentPage = homePage;
      } else if (_currentIndex == calendarPageIndex) {
        _currentPage = calendarPage;
      } else if (_currentIndex == unduhPageIndex) {
        _currentPage = unduhPage;
      } else {
        _currentPage = ckpPage;
      }
    }

    return widget.bidang != null
        ? Scaffold(
            drawer: Drawer(
              child: _createDrawer(),
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      height: widget.headerHeight,
                      child: Container(),
                    ),
                    (_isDetailLoading |
                            _isListPegawaiLoading |
                            _isKeteranganLoading)
                        ? Align(
                            child: LinearProgressIndicator(),
                            alignment: Alignment.bottomCenter,
                          )
                        : Container(),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: calendarPage)
              ],
            ),
            key: widget.scaffoldKey,
          )
        : BlocProvider<UnduhBloc>(
            create: (context) {
              return _unduhBloc;
            },
            child: Scaffold(
              drawer: Drawer(
                child: _createDrawer(),
              ),
              key: widget.scaffoldKey,
              body: SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: CustomFadeAnimationWidget(
                      animation: _fadePageAnimation,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: widget.headerHeight,
                                child: Container(),
                              ),
                              (_isDetailLoading |
                                      _isListPegawaiLoading |
                                      _isKeteranganLoading)
                                  ? Align(
                                      child: LinearProgressIndicator(),
                                      alignment: Alignment.bottomCenter,
                                    )
                                  : Container(),
                            ],
                          ),
                          CustomFadeAnimationWidget(
                            child: _currentPage,
                            animation: _fadeEverythingWhenFab1Clicked,
                          ),
                          Positioned(
                            bottom: 0,
                            child: AnimatedBuilder(
                              animation: _fabBackgroundAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: 0.8,
                                  child: Material(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_fabOptionIsOpen) {
                                          _fabAnimationController.reverse();
                                          _fabOptionIsOpen = false;
                                        }
                                      },
                                      child: Container(
                                        height: _fabBackgroundAnimation.value,
                                        width: widget.width,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50),
                                                topRight: Radius.circular(50))),
                                      ),
                                    ),
                                    elevation: 6,
                                  ),
                                );
                              },
                              child: Container(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: widget.width,
                              child: CustomTranslateAnimationWidget(
                                animation: _translateFabAnimation1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomFadeAnimationWidget(
                                      animation: _fadeEverythingWhenFab1Clicked,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: CustomFadeAnimationWidget(
                                          animation: _fadeFabTextAnimation,
                                          child: _createTextFab(
                                              "Keterangan", "Absensi"),
                                        ),
                                      ),
                                    ),
                                    CustomFadeAnimationWidget(
                                      animation: _fadeFabAnimation,
                                      child:
                                          CustomScaleContainerAnimationWidget(
                                        animation: _scaleFabAnimation,
                                        child: (_fabClicked == fab2Clicked)
                                            ? CustomFadeAnimationWidget(
                                                animation:
                                                    _fadeEverythingWhenFab1Clicked,
                                                child: _createFloatingButton(
                                                    Icon(Icons.add_circle),
                                                    "Add Absensi",
                                                    fab1Clicked))
                                            : _createFloatingButton(
                                                Icon(Icons.add_circle),
                                                "Add Absensi",
                                                fab1Clicked),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: widget.width,
                              child: CustomTranslateAnimationWidget(
                                animation: _translateFabAnimation2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: CustomFadeAnimationWidget(
                                        animation: _fadeFabTextAnimation,
                                        child: CustomFadeAnimationWidget(
                                          animation:
                                              _fadeEverythingWhenFab1Clicked,
                                          child:
                                              _createTextFab("CKP", "Harian"),
                                        ),
                                      ),
                                    ),
                                    CustomFadeAnimationWidget(
                                      animation: _fadeFabAnimation,
                                      child:
                                          CustomScaleContainerAnimationWidget(
                                        animation: _scaleFabAnimation,
                                        child: (_fabClicked == fab1Clicked)
                                            ? CustomFadeAnimationWidget(
                                                animation:
                                                    _fadeEverythingWhenFab1Clicked,
                                                child: _createFloatingButton(
                                                    Icon(Icons.playlist_add),
                                                    "Add CKP",
                                                    fab2Clicked))
                                            : _createFloatingButton(
                                                Icon(Icons.playlist_add),
                                                "Add CKP",
                                                fab2Clicked),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              bottomNavigationBar: CustomTranslateAnimationWidget(
                  animation: _translateNavyBar,
                  child: BottomAppBar(
                    elevation: 8,
                    clipBehavior: Clip.antiAlias,
                    child: CustomBottomNavBar(
                      animationDuration: Duration(milliseconds: 300),
                      items: [
                        BottomNavyBarItem(
                            icon: Icon(Icons.home), title: "Home"),
                        BottomNavyBarItem(
                            icon: Icon(Icons.date_range), title: "Calendar"),
                        BottomNavyBarItem(
                            icon: Icon(Icons.file_download), title: "Unduh"),
                        BottomNavyBarItem(
                            icon: Icon(Icons.exit_to_app), title: "Sign Out")
                      ],
                      onItemSelected: (index) {
                        if (_fabOptionIsOpen) {
                          _fabAnimationController.reverse();
                          _fabOptionIsOpen = false;
                        }
                        _fadePageAnimationController.reset();
                        setState(() {
                          _currentIndex = index;
                        });
                        if (_fadePageAnimation.status ==
                            AnimationStatus.completed) {
                          _fadePageAnimationController.reset();
                        }
                        _fadePageAnimationController.forward().orCancel;
                      },
                      selectedIndex: _currentIndex,
                    ),
                    shape: CircularNotchedRectangle(),
                  )),
              floatingActionButton: CustomFadeAnimationWidget(
                animation: _fadeEverythingWhenFab1Clicked,
                child: FloatingActionButton(
                  heroTag: "main fab",
                  child: AnimatedBuilder(
                    animation: _fabRotate,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _fabRotate.value,
                        child: child,
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahKegiatanPage(
                          pegawai: widget.selectedPegawai);
                    }));

                    /*if (_fabOptionIsOpen) {
                      _fabAnimationController.reverse();
                      _fabOptionIsOpen = false;
                    } else {
                      _fabAnimationController.forward().orCancel;
                      _fabOptionIsOpen = true;
                    }*/
                  },
                  mini: true,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          );
  }

  AnimatedBuilder builder(int slideIndex) {
    int totalItemCount = widget.staticSixWeekFormat
        ? 42
        : DateTime(
              _dates[slideIndex].year,
              _dates[slideIndex].month + 1,
              0,
            ).day +
            _startWeekday +
            (7 - _endWeekday);
    int year = _dates[slideIndex].year;
    int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            /*height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,*/
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: GridView.count(
                  physics: widget.customGridViewPhysics,
                  crossAxisCount: 7,
                  childAspectRatio: _calculateChildAspectRatio(),
                  padding: EdgeInsets.zero,
                  children: List.generate(totalItemCount,

                      /// last day of month + weekday
                      (index) {
                    bool isToday =
                        DateTime.now().day == index + 1 - _startWeekday &&
                            DateTime.now().month == month &&
                            DateTime.now().year == year;
                    bool isSelectedDay = widget.selectedDateTime != null &&
                        widget.selectedDateTime.year == year &&
                        widget.selectedDateTime.month == month &&
                        widget.selectedDateTime.day ==
                            index + 1 - _startWeekday;
                    bool isPrevMonthDay = index < _startWeekday;
                    bool isNextMonthDay = index >=
                        (DateTime(year, month + 1, 0).day) + _startWeekday;
                    bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                    DateTime now = DateTime(year, month, 1);
                    //TextStyle textStyle;
                    TextStyle defaultTextStyle;
                    if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                      now = now.subtract(Duration(days: _startWeekday - index));
                      //textStyle = widget.prevDaysTextStyle;
                      defaultTextStyle = defaultPrevDaysTextStyle;
                    } else if (isThisMonthDay) {
                      now = DateTime(year, month, index + 1 - _startWeekday);
                      /*textStyle = isSelectedDay
                          ? widget.selectedDayTextStyle
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;*/
                      defaultTextStyle = isSelectedDay
                          ? defaultSelectedDayTextStyle
                          : isToday
                              ? defaultTodayTextStyle
                              : defaultDaysTextStyle;
                    } else if (!widget.showOnlyCurrentMonthDate) {
                      now = DateTime(year, month, index + 1 - _startWeekday);
                      //textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = defaultNextDaysTextStyle;
                    } else {
                      return Container();
                    }
                    bool isSelectable = true;
                    if (widget.minSelectedDate != null &&
                        now.millisecondsSinceEpoch <
                            widget.minSelectedDate.millisecondsSinceEpoch)
                      isSelectable = false;
                    else if (widget.maxSelectedDate != null &&
                        now.millisecondsSinceEpoch >
                            widget.maxSelectedDate.millisecondsSinceEpoch)
                      isSelectable = false;
                    return Container(
                      margin: EdgeInsets.all(widget.dayPadding),
                      child: FlatButton(
                        color: isSelectedDay &&
                                widget.selectedDayButtonColor != null
                            ? widget.selectedDayButtonColor
                            : isToday && widget.todayButtonColor != null
                                ? widget.todayButtonColor
                                : widget.dayButtonColor,
                        onPressed: () => _onDayPressed(now),
                        padding: EdgeInsets.all(widget.dayPadding),
                        shape: widget.daysHaveCircularBorder == null
                            ? CircleBorder()
                            : widget.daysHaveCircularBorder
                                ? CircleBorder(
                                    side: BorderSide(
                                      color: isSelectedDay
                                          ? widget.selectedDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : isPrevMonthDay
                                                  ? widget
                                                      .prevMonthDayBorderColor
                                                  : isNextMonthDay
                                                      ? widget
                                                          .nextMonthDayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                    ),
                                  )
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 0.1,
                                      color: isSelectedDay
                                          ? widget.selectedDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : isPrevMonthDay
                                                  ? widget
                                                      .prevMonthDayBorderColor
                                                  : isNextMonthDay
                                                      ? widget
                                                          .nextMonthDayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                    ),
                                  ),
                        child: Stack(
                          children: <Widget>[
                            _mapDatetimeAfterPost.getEvents(now).length > 0
                                ? FadeTransition(
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.amberAccent[100],
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                    ),
                                    opacity: _animationAfterPost,
                                  )
                                : Container(),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: DefaultTextStyle(
                                    style: (_localeDate.dateSymbols.WEEKENDRANGE
                                                .contains((index -
                                                        1 +
                                                        firstDayOfWeek) %
                                                    7)) &&
                                            !isSelectedDay &&
                                            !isToday
                                        ? (isPrevMonthDay
                                            ? defaultPrevDaysTextStyle
                                            : isNextMonthDay
                                                ? defaultNextDaysTextStyle
                                                : isSelectable
                                                    ? defaultWeekendTextStyle
                                                    : defaultInactiveWeekendTextStyle)
                                        : isToday
                                            ? defaultTodayTextStyle
                                            : isSelectable
                                                ? defaultTextStyle
                                                : defaultInactiveDaysTextStyle,
                                    child: Text(
                                      '${now.day}',
                                      style: (_localeDate
                                                  .dateSymbols.WEEKENDRANGE
                                                  .contains((index -
                                                          1 +
                                                          firstDayOfWeek) %
                                                      7)) &&
                                              !isSelectedDay &&
                                              isThisMonthDay &&
                                              !isToday
                                          ? (isSelectable
                                              ? widget.weekendTextStyle
                                              : widget.inactiveWeekendTextStyle)
                                          : isPrevMonthDay
                                              ? widget.prevDaysTextStyle
                                              : isNextMonthDay
                                                  ? widget.nextDaysTextStyle
                                                  : isSelectedDay
                                                      ? widget
                                                          .selectedDayTextStyle
                                                      : isToday
                                                          ? widget
                                                              .todayTextStyle
                                                          : isSelectable
                                                              ? widget
                                                                  .daysTextStyle
                                                              : widget
                                                                  .inactiveDaysTextStyle,
                                      maxLines: 1,
                                    ),
                                  ),
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(top: 5),
                                ),
                                widget.mapPegawaiEvent
                                            .isMapsNull(_selectedPegawai) !=
                                        null
                                    ? !isPrevMonthDay
                                        ? !isNextMonthDay
                                            ? _renderMarkedMapContainer(now)
                                            : _renderMarked(now)
                                        : _renderMarked(now)
                                    : _renderMarked(now),
                              ],
                            ),
                            widget.mapKeteranganEvent
                                        .isMapsNull(_selectedPegawai) !=
                                    null
                                ? !isPrevMonthDay
                                    ? !isNextMonthDay
                                        ? _renderKeteranganMap(now)
                                        : Container()
                                    : Container()
                                : Container()
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getDaysInWeek([DateTime selectedDate]) {
    if (selectedDate == null) selectedDate = new DateTime.now();

    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selectedDate);

    return Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList();
  }

  void _onDayPressed(DateTime picked) {
    if (picked == null) return;
    if (widget.minSelectedDate != null &&
        picked.millisecondsSinceEpoch <
            widget.minSelectedDate.millisecondsSinceEpoch) return;
    if (widget.maxSelectedDate != null &&
        picked.millisecondsSinceEpoch >
            widget.maxSelectedDate.millisecondsSinceEpoch) return;
    setState(() {
      _isReloadSelectedDate = false;
      _selectedDate = picked;
    });

    _navigateToDetail(
        widget.bidang != null
            ? widget.pegawaiList.maps[_selectedPegawai]
            : widget.selectedPegawai,
        picked,
        !widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)
            ? widget.mapPegawaiEvent.maps[_selectedPegawai].getEvents(picked)
            : [],
        !widget.mapKeteranganEvent.isMapsNull(_selectedPegawai)
            ? widget.mapKeteranganEvent.maps[_selectedPegawai].getEvents(picked)
            : []);
    //_setDate();
  }

  Future<Null> _selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: widget.minSelectedDate != null
          ? widget.minSelectedDate
          : DateTime(1960),
      lastDate: widget.maxSelectedDate != null
          ? widget.maxSelectedDate
          : DateTime(2050),
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _isReloadSelectedDate = false;
        _selectedDate = selected;
      });

      _navigateToDetail(
          widget.pegawaiList.maps[_selectedPegawai],
          selected,
          !widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)
              ? widget.mapPegawaiEvent.maps[_selectedPegawai]
                  .getEvents(selected)
              : [],
          !widget.mapKeteranganEvent.isMapsNull(_selectedPegawai)
              ? widget.mapKeteranganEvent.maps[_selectedPegawai]
                  .getEvents(selected)
              : []);

      //_setDate();
    }
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    DateTime date0 =
        DateTime(this._selectedDate.year, this._selectedDate.month - 1, 1);
    DateTime date1 =
        DateTime(this._selectedDate.year, this._selectedDate.month, 1);
    DateTime date2 =
        DateTime(this._selectedDate.year, this._selectedDate.month + 1, 1);

    /// Setup week-only format
    DateTime now = this._selectedDate;
    List<DateTime> week0 = _getDaysInWeek(now.subtract(new Duration(days: 7)));
    List<DateTime> week1 = _getDaysInWeek(now);
    List<DateTime> week2 = _getDaysInWeek(now.add(new Duration(days: 7)));

    _startWeekday = date1.weekday - firstDayOfWeek;
    _endWeekday = date2.weekday - firstDayOfWeek;
    this._dates = [
      date0,
      date1,
      date2,
    ];
    this._weeks = [
      week0,
      week1,
      week2,
    ];
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(() {
        _isReloadSelectedDate = false;
        _setDatesAndWeeks();
        _getAllPegawai();
      });
    } else if (page == 1) {
      return;
    } else {
      if (widget.weekFormat) {
        DateTime curr;
        List<List<DateTime>> newWeeks = this._weeks;
        if (page == 0) {
          curr = _weeks[0].first;
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page += 1;
        } else if (page == 2) {
          curr = _weeks[2].first;
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page -= 1;
        }
        setState(() {
          _isReloadSelectedDate = false;
          this._weeks = newWeeks;
        });

        _controller.animateToPage(page,
            duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      } else {
        List<DateTime> dates = this._dates;
        if (page == 0) {
          dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
          dates[1] = DateTime(dates[0].year, dates[0].month, 1);
          dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
          page = page + 1;
        } else if (page == 2) {
          dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
          dates[1] = DateTime(dates[2].year, dates[2].month, 1);
          dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
          page = page - 1;
        }

        setState(() {
          _isReloadSelectedDate = false;
          _startWeekday = dates[page].weekday - firstDayOfWeek;
          _endWeekday = dates[page + 1].weekday - firstDayOfWeek;
          this._dates = dates;
        });

        _controller
            .animateToPage(page,
                duration: Duration(milliseconds: 1), curve: Threshold(0.0))
            .then((value) {});

        _getDetailAbsensi(_selectedPegawai, _dates[1]);
        _getKeteranganAbsensi(_selectedPegawai, _dates[1]);
      }
    }

    //call callback
    if (this._dates.length == 3 && widget.onCalendarChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isReloadSelectedDate = false;
        widget.onCalendarChanged(!widget.weekFormat
            ? this._dates[1]
            : this._weeks[1][firstDayOfWeek]);
      });
    }
  }

  Widget _renderMarked(DateTime now) {
    if (widget.markedDates != null && widget.markedDates.length > 0) {
      List<DateTime> markedDates = widget.markedDates.map((date) {
        return DateTime(date.year, date.month, date.day);
      }).toList();
      if (markedDates.contains(now)) {
        return widget.markedDateWidget != null
            ? widget.markedDateWidget
            : defaultMarkedDateWidget;
      }
    }
    return Container();
  }

  Widget _renderMarkedMapContainer(DateTime now) {
    if (widget.markedDateShowIcon) {
      return Stack(
        children: [_renderMarkedMap(now)],
      );
    } else {
      return Container(
        height: double.infinity,
        child: _renderMarkedMap(now),
      );
    }
  }

  Widget _renderMarkedMap(DateTime now) {
    if (!widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)) {
      if (widget.mapPegawaiEvent.maps[_selectedPegawai].getEvents(now).length >
          0) {
        List<DetailAbsensi> detailAbsensi =
            widget.mapPegawaiEvent.maps[_selectedPegawai].getEvents(now);
        return FadeTransition(
            opacity: _animationAbsensiEvent,
            child: Column(children: _eventsWidget(detailAbsensi)));
      }
    }
    return Container();
  }

  List<Widget> _eventsWidget(List<DetailAbsensi> details) {
    List<Widget> tmp = [];
    for (int i = 0; i < details.length; i++) {
      Color bg;
      if (i == 0) {
        if (_isTelat(details[i])) {
          bg = widget.telatColor;
        } else {
          bg = widget.masukColor;
        }
      } else {
        if (_isPsw(details[i])) {
          bg = widget.telatColor;
        } else {
          bg = widget.pulangColor;
        }
      }
      tmp.add(Hero(
        child: Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: bg,
          ),
          child: Text(
            '${details[i].time}',
            style: widget.eventTextStyle != null
                ? widget.eventTextStyle
                : defaultEventTextStyle,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(0),
          width: widget.width / 7 - 5,
          height: widget.height / 30,
          alignment: Alignment.center,
        ),
        tag: (new DateFormat('dd MM yyyy')).format(details[i].dateTime) + '$i',
      ));
    }
    return tmp;
  }

  Widget _renderKeteranganMap(DateTime now) {
    if (!widget.mapKeteranganEvent.isMapsNull(_selectedPegawai)) {
      if (widget.mapKeteranganEvent.maps[_selectedPegawai]
              .getEvents(now)
              .length >
          0) {
        return FadeTransition(
            opacity: _animationKeterangan,
            child: Container(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.check_circle,
                color: Colors.red[600],
                size: 13,
              ),
            ));
      }
    }
    return Container();
  }

  _calculateChildAspectRatio() {
    var x = (MediaQuery.of(context).size.width / 7) /
        ((widget.height - widget.headerHeight - widget.weekdayRowHeight) / 6);
    return x;
  }

  _addEventToCalendar(DetailAbsensi absen) {
    _mapAbsensi.add(
        new DateTime(
            absen.dateTime.year, absen.dateTime.month, absen.dateTime.day),
        absen);
  }

  bool _getDetailAbsensi(String nip, DateTime date) {
    bool shouldGetData = !_isDataEventExist(date);
    if (shouldGetData) {
      _isDetailLoading = true;
      _animationEventController.reset();
      APITAD.getData(nip, date).then((response) {
        _animationEventController.forward().orCancel;
        if (response.statusCode == 500) {
          _showSnackBar("Gagal mengambil data absensi");
        } else if (response.statusCode == 200) {
          Map jsonResponse = jsonDecode(response.body);
          if (jsonResponse.length > 0) {
            EventsAbsensi eventsAbsensi = EventsAbsensi.fromJson(jsonResponse);
            _mapAbsensi = new MapEvent();
            eventsAbsensi.events.forEach((absen) => _addEventToCalendar(absen));
            _mapAbsensi.events.forEach((date, list) {
              _cleanEvents(date, list);
            });
            if (eventsAbsensi.events != null) {
              widget.mapPegawaiEvent.add(_selectedPegawai, _mapAbsensi);
            }
          }
        }
        return true;
      }).catchError((error) {
        _showSnackBar("Gagal Mengambil data absensi");
      }).whenComplete(() {
        setState(() {
          _isDetailLoading = false;
          _isReloadSelectedDate = false;
        });
      });
    }
    return false;
  }

  bool _isDataEventExist(DateTime dateTime) {
    if (!widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)) {
      bool isDataExist = false;
      var lastDayDateTime = (dateTime.month < 12)
          ? new DateTime(dateTime.year, dateTime.month + 1, 0)
          : new DateTime(dateTime.year + 1, 1, 0);
      for (int i = 1; i <= lastDayDateTime.day; i++) {
        if (widget.mapPegawaiEvent.maps[_selectedPegawai]
                .getEvents(new DateTime(dateTime.year, dateTime.month, i))
                .length !=
            0) {
          isDataExist = true;
          break;
        }
      }
      return isDataExist;
    } else {
      return false;
    }
  }

  void _cleanEvents(DateTime date, List<DetailAbsensi> events) {
    int tresholdDuty = 12 * 3600;
    bool isWeekday = (date.weekday != DateTime.saturday) &&
        (date.weekday != DateTime.sunday);
    if (isWeekday) {
      //Jika weekday perlu cleaning
      events.sort(
          (a, b) => a.dateTime.millisecond.compareTo(b.dateTime.millisecond));

      //Ambil absen pertama dan terakhir
      if (events.length > 2) {
        events.removeRange(1, events.length - 1);
      }

      //Ambil satu absen datang dan pulang
      List<DetailAbsensi> listDatang = [];
      List<DetailAbsensi> listPulang = [];

      for (int i = 0; i < events.length; i++) {
        int minute = events[i].dateTime.minute;
        int hour = events[i].dateTime.hour;
        int second = events[i].dateTime.second;
        int milisec = hour * 3600 + minute * 60 + second;
        if (milisec < tresholdDuty) {
          listDatang.add(events[i]);
        } else {
          listPulang.add(events[i]);
        }
      }

      events.clear();
      if (listDatang.length > 0) {
        events.add(listDatang.first);
      }
      if (listPulang.length > 0) {
        events.add(listPulang.last);
      }
    } else {
      //Jika weekend langsung ambil pertama dan terakhir
      events.sort(
          (a, b) => a.dateTime.millisecond.compareTo(b.dateTime.millisecond));

      //Ambil absen pertama dan terakhir
      if (events.length > 2) {
        events.removeRange(1, events.length - 1);
      }
    }

    //Tambah events kosong jika hanya absen datang atau pulang
    if (events.length == 1) {
      int minute = events[0].dateTime.minute;
      int hour = events[0].dateTime.hour;
      int second = events[0].dateTime.second;
      int milisec = hour * 3600 + minute * 60 + second;
      if (milisec < tresholdDuty) {
        events.add(new DetailAbsensi(dateTime: events[0].dateTime, time: "-"));
      } else {
        events.insert(
            0, new DetailAbsensi(dateTime: events[0].dateTime, time: "-"));
      }
    }
  }

  bool _getAllPegawai() {
    _isListPegawaiLoading = true;

    if (widget.bidang != null) {
      ApiCustom.getAllPegawai(widget.bidang.id).then((response) {
        var jsonResponse = jsonDecode(response.body);
        PegawaiList list = PegawaiList.fromJson(jsonResponse);
        list.list
            .forEach((pegawai) => widget.pegawaiList.add(pegawai.nip, pegawai));
        _selectedPegawai = list.list[0].nip;

        _getDetailAbsensi(_selectedPegawai, _dates[1]);
        _getKeteranganAbsensi(_selectedPegawai, _dates[1]);
      }).catchError((error) {
        _showSnackBar("Gagal mengambil data pegawai");
      }).whenComplete(() {
        setState(() {
          _isListPegawaiLoading = false;
          _isReloadSelectedDate = false;
        });
      });
    } else {
      _selectedPegawai = widget.selectedPegawai.nip;

      _getDetailAbsensi(_selectedPegawai, _dates[1]);
      _getKeteranganAbsensi(_selectedPegawai, _dates[1]);

      setState(() {
        _isListPegawaiLoading = false;
        _isReloadSelectedDate = false;
      });
    }

    return true;
  }

  List<DropdownMenuItem<String>> _createDropdownItems() {
    List<DropdownMenuItem<String>> tmp = [];
    widget.pegawaiList.maps
        .forEach((id, pegawai) => tmp.add(DropdownMenuItem<String>(
            child: Text(
              pegawai.nama,
              overflow: TextOverflow.ellipsis,
              style: widget.headerTextStyle != null
                  ? widget.headerTextStyle
                  : defaultHeaderTextStyle,
            ),
            value: id)));
    return tmp;
  }

  bool _onPegawaiChanged() {
    _getDetailAbsensi(_selectedPegawai, _dates[1]);
    _getKeteranganAbsensi(_selectedPegawai, _dates[1]);
    return true;
  }

  _getKeteranganAbsensi(String nip, DateTime date) {
    bool shouldGetData = !_isDataKeteranganExist(date);
    if (shouldGetData) {
      _isKeteranganLoading = true;
      _animationKeteranganController.reset();
      ApiCustom.getPegawaiAbsensi(nip, date).then((response) {
        _animationKeteranganController.forward().orCancel;
        var jsonresponse = jsonDecode(response.body);
        KeteranganAbsensiList list =
            KeteranganAbsensiList.fromJson(jsonresponse);
        _mapKeterangan = new MapEvent();
        list.list.forEach((keterangan) {
          _mapKeterangan.add(keterangan.dateTime, keterangan);
        });
        if (_mapKeterangan.events != null) {
          widget.mapKeteranganEvent.add(_selectedPegawai, _mapKeterangan);
        }
      }).catchError((error) {
        _showSnackBar("Gagal mengambil data keterangan absensi");
      }).whenComplete(() {
        setState(() {
          _isKeteranganLoading = false;
          _isReloadSelectedDate = false;
        });
      });
    }
  }

  bool _isDataKeteranganExist(DateTime dateTime) {
    if (!widget.mapKeteranganEvent.isMapsNull(_selectedPegawai)) {
      bool isDataExist = false;
      var lastDayDateTime = (dateTime.month < 12)
          ? new DateTime(dateTime.year, dateTime.month + 1, 0)
          : new DateTime(dateTime.year + 1, 1, 0);
      for (int i = 1; i <= lastDayDateTime.day; i++) {
        if (widget.mapKeteranganEvent.maps[_selectedPegawai]
                .getEvents(new DateTime(dateTime.year, dateTime.month, i))
                .length >
            0) {
          isDataExist = true;
          break;
        }
      }
      return isDataExist;
    } else {
      return false;
    }
  }

  void _navigateToDetail(
      Pegawai pegawai,
      DateTime date,
      List<DetailAbsensi> detailAbsensi,
      List<KeteranganAbsensi> keterangan) async {
    _mapDatetimeAfterPost = new MapEvent();
    final result = await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => DetailAbsensiPage(
                  pegawai: pegawai,
                  dateTime: date,
                  details: detailAbsensi,
                  keterangan: keterangan,
                ),
            transitionsBuilder: (context, anim1, anim2, child) =>
                FadeTransition(
                  child: child,
                  opacity: anim1,
                )));

    //Do something here to show result
    if (result.status == StatusPage.afterPost) {
      KeteranganAbsensi absensi = result.keteranganAbsensi;
      _animationAfterPostController.reset();
      _mapDatetimeAfterPost.add(result.dateTime, true);
      _mapKeterangan = new MapEvent();
      _mapKeterangan.add(absensi.dateTime, absensi);
      widget.mapKeteranganEvent.add(_selectedPegawai, _mapKeterangan);
    } else if (result.status == StatusPage.afterDelete) {
      _animationAfterPostController.reset();
      _mapDatetimeAfterPost.add(result.dateTime, true);
      widget.mapKeteranganEvent.maps[_selectedPegawai].events
          .remove(result.dateTime);
    }

    setState(() {
      _isReloadSelectedDate = false;
      _animationAfterPostController.reverse(from: 100);
    });
  }

  void _showSnackBar(String message) {
    if (!widget.scaffoldKey.currentState.isDrawerOpen) {
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(milliseconds: 700),
          content: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.warning,
                  size: 15,
                ),
                margin: EdgeInsets.only(right: 5),
              ),
              Text(
                message,
                style: TextStyle(fontSize: 15),
              )
            ],
          )));
    }
  }

  List<DetailAbsensi> _getAbsensiToday(DateTime now) {
    List<DetailAbsensi> tmp = [];
    DetailAbsensi empty = new DetailAbsensi(dateTime: now, time: "-");
    tmp.addAll([empty, empty]);
    if (!widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)) {
      if (widget.mapPegawaiEvent.maps[_selectedPegawai]
              .getEvents(new DateTime(now.year, now.month, now.day))
              .length !=
          0) {
        tmp = [];
        tmp = widget.mapPegawaiEvent.maps[_selectedPegawai]
            .getEvents(new DateTime(now.year, now.month, now.day));
      }
    }

    return tmp;
  }

  Statistik _generateStatistik(DateTime now) {
    var lastDayDateTime = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 0)
        : new DateTime(now.year + 1, 1, 0);
    Statistik tmp = Statistik(
        cutiFreq: null,
        sakitFreq: null,
        tanpaKeteranganFreq: null,
        telatFreq: null,
        tugasFreq: null);
    for (int i = 1; i <= lastDayDateTime.day; i++) {
      if (!widget.mapPegawaiEvent.isMapsNull(_selectedPegawai)) {
        if (widget.mapPegawaiEvent.maps[_selectedPegawai]
                .getEvents(new DateTime(now.year, now.month, i))
                .length !=
            0) {
          DetailAbsensi detailAbsensi = widget
              .mapPegawaiEvent.maps[_selectedPegawai]
              .getEvents(new DateTime(now.year, now.month, i))[0];
          if (detailAbsensi.time != '-') {
            if (_isTelat(detailAbsensi)) {
              if (tmp.telatFreq == null) {
                tmp.telatFreq = 0;
              }
              tmp.telatFreq++;
            }
          }
        }
      }

      if (!widget.mapKeteranganEvent.isMapsNull(_selectedPegawai)) {
        if (widget.mapKeteranganEvent.maps[_selectedPegawai]
                .getEvents(new DateTime(now.year, now.month, i))
                .length >
            0) {
          if (tmp.sakitFreq == null) {
            tmp.sakitFreq = 0;
            tmp.tanpaKeteranganFreq = 0;
            tmp.tugasFreq = 0;
            tmp.cutiFreq = 0;
          }
          KeteranganAbsensi keteranganAbsensi = widget
              .mapKeteranganEvent.maps[_selectedPegawai]
              .getEvents(new DateTime(now.year, now.month, i))[0];
          String s = keteranganAbsensi.status.id;

          if (s == "1") {
            tmp.sakitFreq++;
          } else if ((s == "2") |
              (s == "3") |
              (s == "4") |
              (s == "5") |
              (s == "6")) {
            tmp.cutiFreq++;
          } else if ((s == "7") | (s == "8")) {
            tmp.tugasFreq++;
          }
        }
      }
    }

    return tmp;
  }

  static bool _isTelat(DetailAbsensi detailAbsensi) {
    bool isWeekday = detailAbsensi.dateTime.weekday != DateTime.saturday &&
        detailAbsensi.dateTime.weekday != DateTime.sunday;
    int minute = detailAbsensi.dateTime.minute;
    int hour = detailAbsensi.dateTime.hour;
    int second = detailAbsensi.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (7 * 3600 + 1800)) & (milisec < (9 * 3600)) & isWeekday) {
      return true;
    } else {
      return false;
    }
  }

  static bool _isPsw(DetailAbsensi detailAbsensi) {
    bool isWeekday = detailAbsensi.dateTime.weekday != DateTime.saturday &&
        detailAbsensi.dateTime.weekday != DateTime.sunday;
    int minute = detailAbsensi.dateTime.minute;
    int hour = detailAbsensi.dateTime.hour;
    int second = detailAbsensi.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (14 * 3600 + 1800)) & (milisec < (16 * 3600)) & isWeekday) {
      return true;
    } else {
      return false;
    }
  }

  Widget _createDrawer() {
    if (widget.bidang != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                SavedPreference.removeAll();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text("SIGN OUT"),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Created by Team IPD",
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Absensi BPS Provinsi NTT",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 95, 255, 100),
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                "images/ic_launcher.png",
                semanticLabel: "logo",
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "Version 2.0",
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Copyright © 2020",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Badan Pusat Statistik Provinsi Nusa Tenggara Timur",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "All rights Reserved",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _createFloatingButton(Icon icon, String tag, int fabClicked) {
    return FittedBox(
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _fabClicked = fabClicked;
            _fabClickedAnimationController.forward().orCancel;
          });
        },
        child: icon,
        heroTag: tag,
      ),
      fit: BoxFit.fill,
    );
  }

  Widget _createTextFab(String string1, String string2) {
    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Tambah",
            style: TextStyle(
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "\n",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: string1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "\n",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: string2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'absensi id', 'absensi name', 'absensi description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      permission = await Permission.storage.request();
    }

    return permission == PermissionStatus.granted;
  }
}

class CustomFadeAnimationWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const CustomFadeAnimationWidget(
      {Key key, @required this.animation, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class CustomTranslateAnimationWidget extends StatelessWidget {
  final Animation<Offset> animation;
  final Widget child;

  const CustomTranslateAnimationWidget(
      {Key key, @required this.animation, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class CustomScaleContainerAnimationWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const CustomScaleContainerAnimationWidget(
      {Key key, @required this.animation, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: animation.value,
          height: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
