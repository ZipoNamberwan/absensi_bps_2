import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_event.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/unduh/unduh_state.dart';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
      await _download((result as Map)['url'], (result as Map)['filename']);

      yield SuccessState((result as Map)['filename'],
          to: state.to, from: state.from);
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

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      permission = await Permission.storage.request();
    }

    return permission == PermissionStatus.granted;
  }

  Future<void> _download(String url, String filename) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, filename);
      await _startDownload(url, savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  Future<void> _startDownload(String url, String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await Dio().download(
        url,
        savePath,
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      //await _showNotification(result);
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await FlutterLocalNotificationsPlugin().show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }
}
