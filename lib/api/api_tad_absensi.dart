import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://webapps.bps.go.id/ntt/tad_absensi/index.php?";

class APITAD {
  static Future getData(String nip, DateTime date) {
    var lastDayDateTime = (date.month < 12)
        ? new DateTime(date.year, date.month + 1, 0)
        : new DateTime(date.year + 1, 1, 0);
    var url = baseUrl +
        "nip=$nip&start_date=${date.year.toString()}-${(date.month).toString().padLeft(2, '0')}-01&end_date=${date.year.toString()}-${(date.month).toString().padLeft(2, '0')}-${lastDayDateTime.day}&ip_mesin=10.53.0.253";
    return http.get(url);
  }
}
