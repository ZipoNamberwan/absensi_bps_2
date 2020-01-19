import 'dart:async';

import 'package:absensi_bps_2/classes/bidang.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bps_2/classes/event_list.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:absensi_bps_2/src/calendar_header.dart';
import 'package:absensi_bps_2/src/weekday_row.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
export 'package:absensi_bps_2/classes/event_list.dart';
import 'package:absensi_bps_2/classes/detail_absensi.dart';
import 'package:absensi_bps_2/api/api_tad_absensi.dart';
import 'package:absensi_bps_2/api/api_custom.dart';
import 'dart:convert';

import 'classes/keterangan_absensi.dart';
import 'classes/statistik.dart';
import 'detail_absensi_page.dart';
import 'home.dart';

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
  final bool
      markedDateMoreShowTotal; // null - no indicator, true - show the total events, false - show the total of hidden events
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
  static final int akunPageIndex = 3;

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
  Animation<double> _animationEvent;
  Animation<double> _animationKeterangan;
  Animation<double> _animationAfterPost;
  bool _isDetailLoading = true;
  bool _isListPegawaiLoading = true;
  bool _isKeteranganLoading = true;
  MapEvent<bool> _mapDatetimeAfterPost = new MapEvent();
  int _currentIndex = 0;
  Widget _currentPage;
  AnimationController _fadeAnimationController;
  Animation<double> _fadeAnimation;
  bool _isAbsensiFirstMonthLoaded = false;
  bool _isKeteranganFirstMonthLoaded = false;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class
  bool _isReloadSelectedDate = true;

  @override
  initState() {
    super.initState();
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

    _animationEventController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _animationKeteranganController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _animationAfterPostController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _animationEvent = CurvedAnimation(
        parent: _animationEventController, curve: Curves.easeIn);

    _animationKeterangan = CurvedAnimation(
        parent: _animationKeteranganController, curve: Curves.easeIn);

    _animationAfterPost = CurvedAnimation(
        parent: _animationAfterPostController, curve: Curves.easeOut);

    _fadeAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: _fadeAnimationController, curve: Curves.easeIn));

    _fadeAnimationController.addListener(() {
      setState(() {});
    });

    _fadeAnimationController.forward().orCancel;

    _setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    _animationAfterPostController.dispose();
    _animationEventController.dispose();
    _animationKeteranganController.dispose();
    _fadeAnimationController.dispose();
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

    Widget akunPage;

    if (widget.bidang == null) {
      homePage = HomePage(
        pegawai: widget.selectedPegawai,
        stat: _generateStatistik(DateTime.now()),
        height: widget.height,
        details: _getAbsensiToday(DateTime.now()),
        headerTextStyle: widget.headerTextStyle,
        onPressedDrawer: widget.onPressedDrawer,
      );

      akunPage = Container();

      if (_currentIndex == homePageIndex) {
        _currentPage = homePage;
      } else if (_currentIndex == calendarPageIndex) {
        _currentPage = calendarPage;
      } else {
        _currentPage = akunPage;
      }
    }

    return widget.bidang != null
        ? Scaffold(
            body: Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: calendarPage),
            key: widget.scaffoldKey,
          )
        : Scaffold(
            drawer: Drawer(
              child: _createDrawer(),
            ),
            key: widget.scaffoldKey,
            body: SingleChildScrollView(
              child:
                  //custom icon
                  Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Opacity(
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
                      _currentPage
                    ],
                  ),
                  opacity: _fadeAnimation.value,
                ),
              ),
            ),
            bottomNavigationBar: BottomNavyBar(
              showElevation: true,
              itemCornerRadius: 15,
              curve: Curves.easeIn,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                //_fadeAnimationController.reset();
                setState(() => _currentIndex = index);
                if (_fadeAnimation.status == AnimationStatus.completed) {
                  _fadeAnimationController.reset();
                }
                _fadeAnimationController.forward().orCancel;
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                    textAlign: TextAlign.center,
                    title: Text('Home'),
                    icon: Icon(Icons.home),
                    activeColor: widget.navItemColorActive,
                    inactiveColor: widget.navItemColorInactive),
                BottomNavyBarItem(
                    textAlign: TextAlign.center,
                    title: Text('Absensi'),
                    icon: Icon(Icons.date_range),
                    activeColor: widget.navItemColorActive,
                    inactiveColor: widget.navItemColorInactive),
              ],
            ));
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
                                          color: Colors.orange,
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
            opacity: _animationEvent,
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
      tmp.add(Container(
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
                Icons.assistant_photo,
                color: Colors.red[900],
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
              _cleanEvents(list);
            });
            if (eventsAbsensi.events != null) {
              widget.mapPegawaiEvent.add(_selectedPegawai, _mapAbsensi);
            }
          }
        }
        return true;
      }).whenComplete(() {
        setState(() {
          _isDetailLoading = false;
          _isReloadSelectedDate = false;
          _isAbsensiFirstMonthLoaded = true;
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
      for (int i = 1; i < lastDayDateTime.day; i++) {
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

  void _cleanEvents(List<DetailAbsensi> events) {
    int tresholdDutyOn = 9 * 3600;
    int tresholdDutyOff = 14 * 3600 + 30 * 60;

    events.sort(
        (a, b) => a.dateTime.millisecond.compareTo(b.dateTime.millisecond));

    //Hilangkan seluruh absen antara pukul 09.00 sampai pukul 14.30
    events.removeWhere((detailAbsensi) {
      int minute = detailAbsensi.dateTime.minute;
      int hour = detailAbsensi.dateTime.hour;
      int second = detailAbsensi.dateTime.second;
      int milisec = hour * 3600 + minute * 60 + second;

      return ((milisec > tresholdDutyOn) & (milisec < tresholdDutyOff));
    });

    //Ambil absen pertama dan terakhir
    if (events.length > 2) {
      events.removeRange(1, events.length - 1);
    }

    //Ambil satu absen datang dan satu absen pulang
    int countDatang = 0;
    int countPulang = 0;

    events.removeWhere((detailAbsensi) {
      int minute = detailAbsensi.dateTime.minute;
      int hour = detailAbsensi.dateTime.hour;
      int second = detailAbsensi.dateTime.second;
      int milisec = hour * 3600 + minute * 60 + second;
      bool ret = false;
      if (milisec < tresholdDutyOn) {
        if (countDatang > 0) {
          ret = true;
        }
        countDatang += 1;
      }
      return ret;
    });

    events.removeWhere((detailAbsensi) {
      //Potensi bug di sini
      int minute = detailAbsensi.dateTime.minute;
      int hour = detailAbsensi.dateTime.hour;
      int second = detailAbsensi.dateTime.second;
      int milisec = hour * 3600 + minute * 60 + second;
      bool ret = false;
      if (milisec > tresholdDutyOff) {
        if (countPulang > 0) {
          ret = true;
        }
        countPulang += 1;
      }
      return ret;
    });

    //Tambah events kosong jika hanya absen datang atau pulang
    if (events.length == 1) {
      int minute = events[0].dateTime.minute;
      int hour = events[0].dateTime.hour;
      int second = events[0].dateTime.second;
      int milisec = hour * 3600 + minute * 60 + second;
      if (milisec < tresholdDutyOn) {
        events.add(new DetailAbsensi(dateTime: events[0].dateTime, time: "-"));
      }
      if (milisec > tresholdDutyOff) {
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
      }).whenComplete(() {
        setState(() {
          _isKeteranganLoading = false;
          _isReloadSelectedDate = false;
          _isKeteranganFirstMonthLoaded = true;
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
      for (int i = 1; i < lastDayDateTime.day; i++) {
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
        MaterialPageRoute(
            builder: (context) => DetailAbsensiPage(
                  pegawai: pegawai,
                  dateTime: date,
                  details: detailAbsensi,
                  keterangan: keterangan,
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
    for (int i = 1; i < lastDayDateTime.day; i++) {
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
    int minute = detailAbsensi.dateTime.minute;
    int hour = detailAbsensi.dateTime.hour;
    int second = detailAbsensi.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (7 * 3600 + 1800)) & (milisec < (9 * 3600))) {
      return true;
    } else {
      return false;
    }
  }

  static bool _isPsw(DetailAbsensi detailAbsensi) {
    int minute = detailAbsensi.dateTime.minute;
    int hour = detailAbsensi.dateTime.hour;
    int second = detailAbsensi.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (14 * 3600 + 1800)) & (milisec < (16 * 3600))) {
      return true;
    } else {
      return false;
    }
  }

  Widget _createDrawer() {
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
