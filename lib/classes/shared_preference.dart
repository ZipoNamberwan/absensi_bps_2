import 'package:shared_preferences/shared_preferences.dart';

import 'bidang.dart';
import 'keterangan_absensi.dart';

class SavedPreference {
  static final String keyIdBidangOld = "Key ID Bidang";
  static final String keyNamaBidangOld = "Key Nama Bidang";
  static final String keyUsernameBidangOld = "Key Username Bidang";
  static final String keyPasswordBidangOld = "Key Password Bidang";

  static final String keyNipPegawaiOld = "Key NIP Pegawai";
  static final String keyNamaPegawaiOld = "Key Nama Pegawai";
  static final String keyFotoPegawaiOld = "Key Foto Pegawai";
  static final String keyNipBaruPegawaiOld = "Key NIP Baru Pegawai";
  static final String keyEmailPegawaiOld = "Key Email Pegawai";

  static final String keyIdBidang = "Key ID Bidang New";
  static final String keyNamaBidang = "Key Nama Bidang New";
  static final String keyUsernameBidang = "Key Username Bidang New";
  static final String keyPasswordBidang = "Key Password Bidang New";

  static final String keyNipPegawai = "Key NIP Pegawai New";
  static final String keyNamaPegawai = "Key Nama Pegawai New";
  static final String keyFotoPegawai = "Key Foto Pegawai New";
  static final String keyNipBaruPegawai = "Key NIP Baru Pegawai New";
  static final String keyEmailPegawai = "Key Email Pegawai New";

  static Future saveBidang(
      String id, String namabidang, String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyIdBidang, id);
    prefs.setString(keyNamaBidang, namabidang);
    prefs.setString(keyUsernameBidang, username);
    prefs.setString(keyPasswordBidang, username);
  }

  static Future savePegawai(String nip, String nama, String foto,
      String nipBaru, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyNipPegawai, nip);
    prefs.setString(keyNamaPegawai, nama);
    prefs.setString(keyFotoPegawai, foto);
    prefs.setString(keyNipBaruPegawai, nipBaru);
    prefs.setString(keyEmailPegawai, email);
  }

  static Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }

  static Future<dynamic> getLogInData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await removeOldPref();
    if (prefs.getString(keyIdBidang) != null) {
      return new Bidang(
          id: prefs.getString(keyIdBidang),
          namabidang: prefs.getString(keyNamaBidang),
          username: prefs.getString(keyUsernameBidang),
          password: prefs.getString(keyPasswordBidang));
    } else if (prefs.get(keyNipPegawai) != null) {
      return new Pegawai(
          nip: prefs.getString(keyNipPegawai),
          nama: prefs.getString(keyNamaPegawai),
          foto: prefs.getString(keyFotoPegawai),
          nipBaru: prefs.getString(keyNipBaruPegawai),
          email: prefs.getString(keyEmailPegawai));
    } else
      return null;
  }

  static Future removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future removeOldPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyIdBidangOld);
    prefs.remove(keyNamaBidangOld);
    prefs.remove(keyUsernameBidangOld);
    prefs.remove(keyPasswordBidangOld);

    prefs.remove(keyNipPegawaiOld);
    prefs.remove(keyNamaPegawaiOld);
    prefs.remove(keyFotoPegawaiOld);
    prefs.remove(keyNipBaruPegawaiOld);
    prefs.remove(keyEmailPegawaiOld);
  }
}
