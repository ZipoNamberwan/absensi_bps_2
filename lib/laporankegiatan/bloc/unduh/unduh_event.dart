import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UnduhEvent extends Equatable {
  const UnduhEvent();
}

class ChangeFromDate extends UnduhEvent {
  final DateTime dateTime;

  ChangeFromDate(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class ChangeToDate extends UnduhEvent {
  final DateTime dateTime;

  ChangeToDate(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class StartDownload extends UnduhEvent {
  StartDownload();

  @override
  List<Object> get props => [];
}
