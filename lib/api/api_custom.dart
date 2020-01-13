import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../classes/post_keterangan_absensi.dart';

const baseUrl = "http://10.0.2.2/apiabsensi/index.php/";
//const baseUrl = "http://bpsnttapp.com/apiabsensi/index.php/";

String uploadEndPoint = '';

class ApiCustom {
  static Future getAllPegawai(String idBidang) {
    var lastUrl = "pegawai?idbidang=$idBidang";
    return http.get(baseUrl + lastUrl);
  }

/*  static Future uploadImage(String fileName, String base64Image) {
    var lastUrl = "upload_image.php";
    return http.post("http://10.0.2.2/sikat/" + lastUrl, body: {
      "image": base64Image,
      "name": fileName,
    });
  }*/

  static Future getStatus() {
    var lastUrl = "status";
    return http.get(baseUrl + lastUrl);
  }

  static Future getPegawaiAbsensi(String nip, DateTime date) {
    var lastDayDateTime = (date.month < 12)
        ? new DateTime(date.year, date.month + 1, 0)
        : new DateTime(date.year + 1, 1, 0);

    String cond1 = "nip=$nip";
    String cond2 =
        "&date_first=${date.year}-${date.month.toString().padLeft(2, '0')}-01&date_last=${date.year}-${date.month.toString().padLeft(2, '0')}-${lastDayDateTime.day.toString().padLeft(2, '0')}";
    var lastUrl = "absensts?$cond1$cond2";
    return http.get(baseUrl + lastUrl);
  }

  static Future<PostKeteranganAbsensi> createPost(
      PostKeteranganAbsensi post) async {
    var lastUrl = 'absensts';

    var bodyJson = jsonEncode({
      "nip": post.nip,
      "keterangan": post.keterangan,
      "status": post.idstatus,
      "tanggal": post.datetime,
      "gambar": post.base64Image,
      "nama_gambar": post.fileName,
    });

    final response = await http.post(
      baseUrl + lastUrl,
      headers: {"Content-Type": "application/json"},
      body: bodyJson,
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return PostKeteranganAbsensi.fromJson(json.decode(response.body));
  }

  static Future<PostKeteranganAbsensi> deletePost(
      PostKeteranganAbsensi post) async {
    var lastUrl = 'hapussts';

    var bodyJson = jsonEncode({
      "nip": post.nip,
      "tanggal": post.datetime,
    });

    final response = await http.post(
      baseUrl + lastUrl,
      headers: {"Content-Type": "application/json"},
      body: bodyJson,
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return PostKeteranganAbsensi.fromJson(json.decode(response.body));
  }

  static Future loginBidang(String username, String password) {
    var lastUrl = "bidang?username=$username&password=$password";
    return http.get(baseUrl + lastUrl);
  }

  static Future<String> loginPegawai(String username, String password) async {
    var lastUrl = 'logincommunity';

    var bodyJson = jsonEncode({
      "username": username,
      "password": password,
    });

    final response = await http.post(
      baseUrl + lastUrl,
      headers: {"Content-Type": "application/json"},
      body: bodyJson,
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return response.body;
  }
}
