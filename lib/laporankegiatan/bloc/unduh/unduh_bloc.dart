import 'dart:async';

import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_event.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_state.dart';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:bloc/bloc.dart';

class UnduhBloc extends Bloc<UnduhEvent, UnduhState> {
  DataRepository repository = DataRepository();

  @override
  UnduhState get initialState => InitialunduhState();

  @override
  Stream<UnduhState> mapEventToState(
    UnduhEvent event,
  ) async* {
    if (event is ChangeFromDate) {
      yield* mapChangeFromDateToState(event.dateTime);
    } else if (event is ChangeToDate) {
      yield* mapChangeToDateToState(event.dateTime);
    } else if (event is StartDownload){

    }
  }

  Stream<UnduhState> mapChangeFromDateToState(DateTime dateTime) async* {
    yield UnduhState(from: dateTime, to: state.to);
  }

  Stream<UnduhState> mapChangeToDateToState(DateTime dateTime) async* {
    yield UnduhState(from: state.from, to: dateTime);
  }
}
