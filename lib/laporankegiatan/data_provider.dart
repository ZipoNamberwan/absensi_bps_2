import 'dart:io';

import 'package:absensi_bps_2/classes/app_exceptions.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/post.dart';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';

class DataProvider {
  String developmentServerUrl = "http://192.168.43.247/newapiabsensi/web/";
  String productionServerUrl = "http://bpsnttapp.com/newapiabsensi/web/";

  Future<dynamic> tambahKegiatan(String nip, Kegiatan kegiatan) async {
    String url = "${developmentServerUrl}kegiatan";

    Map<String, dynamic> formData = {
      //required
      "pegawai": nip,
      "tanggal": DateFormat('yyyy-mm-dd').format(kegiatan.tanggal),
      "namakegiatan": kegiatan.detailKegiatan.nama,
      "satuankegiatan": kegiatan.detailKegiatan.satuan,
      "volume": kegiatan.volume.toString(),
      //optional
      //"durasi": kegiatan.durasi.toString(),
      //"satuandurasi": kegiatan.satuanDurasi.id,
      //"statuskegiatan": kegiatan.statusKegiatan.id,
      //"pemberitugas": kegiatan.pemberiTugas,
      //"keterangan": kegiatan.keterangan,
    };
    if (kegiatan.durasi != null) {
      formData['durasi'] = kegiatan.durasi.toString();
    }
    if (kegiatan.satuanDurasi != null) {
      formData['satuandurasi'] = kegiatan.satuanDurasi.id;
    }
    if (kegiatan.statusKegiatan != null) {
      formData['statuskegiatan'] = kegiatan.statusKegiatan.id;
    }
    if (kegiatan.pemberiTugas != null) {
      formData['pemberitugas'] = kegiatan.pemberiTugas;
    }
    if (kegiatan.keterangan != null) {
      formData['keterangan'] = kegiatan.keterangan;
    }

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            Headers.contentTypeHeader: "application/json", // set content-length
          },
        ),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getKegiatan(String nip, String tanggal) async {
    String url =
        "${developmentServerUrl}kegiatan?tanggal=$tanggal&pegawai=$nip";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getHistoryKegiatan(String nip, String searchText) async {
    String url =
        "${developmentServerUrl}history-kegiatan?fields=namakegiatan,satuankegiatan&namakegiatan=$searchText&pegawai=$nip";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            Headers.contentTypeHeader: "application/json", // set content-length
          },
        ),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getStatus() async {
    String url = "${developmentServerUrl}statuskegiatan";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getSatuanDurasi() async {
    String url = "${developmentServerUrl}satuandurasi";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(var response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        //responseJson = json.decode(response.data);
        return Post(
            isSuccess: response.data['success'],
            code: response.data['code'],
            message: response.data['message'],
            data: response.data['data']);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException('Error Communicating with server');
    }
  }
}