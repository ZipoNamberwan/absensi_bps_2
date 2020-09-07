import 'dart:async';
import 'dart:io';

import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_event.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_state.dart';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
    } else if (event is StartDownload) {
      yield* mapStartDownloadToState(event.nip);
    }
  }

  Stream<UnduhState> mapChangeFromDateToState(DateTime dateTime) async* {
    yield UnduhState(from: dateTime, to: state.to);
  }

  Stream<UnduhState> mapChangeToDateToState(DateTime dateTime) async* {
    yield UnduhState(from: state.from, to: dateTime);
  }

  Stream<UnduhState> mapStartDownloadToState(String nip) async* {
    yield LoadingState(to: state.to, from: state.from);
    try {
      var result = await repository.initDownload(
          nip,
          DateFormat('yyyy-MM-dd').format(state.from),
          DateFormat('yyyy-MM-dd').format(state.to));

      //download here
      final dir = await _getDownloadDirectory();

      Map<String, dynamic> mapResult = {
        'isSuccess': false,
        'filePath': null,
        'error': null,
        'filename': null,
      };

      final savePath = path.join(dir.path, (result as Map)['filename']);

      final response = await Dio().download(
        (result as Map)['url'],
        savePath,
      );

      mapResult['isSuccess'] = response.statusCode == 200;
      mapResult['filePath'] = savePath;
      mapResult['filename'] = (result as Map)['filename'];

      if (mapResult['isSuccess']) {
        yield SuccessState(mapResult, to: state.to, from: state.from);
        yield UnduhState(to: state.to, from: state.from);
      } else {
        yield ErrorState("Something wrong happen",
            to: state.to, from: state.from);
      }
    } catch (e) {
      yield ErrorState(e.toString(), from: state.from, to: state.to);
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }
}
