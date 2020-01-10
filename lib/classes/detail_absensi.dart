class DetailAbsensi {
  DateTime dateTime;
  String time;

  DetailAbsensi({this.dateTime, this.time});

  factory DetailAbsensi.fromJson(Map<String, dynamic> parsedJson) {
    return DetailAbsensi(
        dateTime: DateTime.parse(parsedJson['DateTime']),
        time: _getClock(DateTime.parse(parsedJson['DateTime'])));
  }

  Map toJson() {
    return {'DateTime': dateTime.toString()};
  }

  static _getClock(DateTime datetime) {
    String clock = "${_toTwoDigitString(datetime.hour) }:${_toTwoDigitString(datetime.minute)}";
    return clock;
  }

  static String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

}

class EventsAbsensi {
  List<DetailAbsensi> events;

  EventsAbsensi({this.events});

  factory EventsAbsensi.fromJson(Map<String, dynamic> json) {
    var list = json['Row'] as List;
    List<DetailAbsensi> listAbsensi =
        list.map((i) => DetailAbsensi.fromJson(i)).toList();
    return EventsAbsensi(events: listAbsensi);
  }
}
