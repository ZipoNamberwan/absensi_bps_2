import 'package:absensi_bps_2/classes/bidang.dart';
import 'package:absensi_bps_2/classes/keterangan_absensi.dart';
import 'package:absensi_bps_2/classes/shared_preference.dart';
import 'package:absensi_bps_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginSSO extends StatefulWidget {
  @override
  _LoginSSOState createState() => _LoginSSOState();
}

class _LoginSSOState extends State<LoginSSO> {
  @override
  void initState() {
    super.initState();
    SavedPreference.getLogInData().then((data) {
      if (data != null) {
        navigateToHome(
            bidang: data is Bidang ? data : null,
            pegawai: data is Pegawai ? data : null);
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrl: "https://webapps.bps.go.id/ntt/sso/index.php",
      onLoadStop: (controller, url) async {
        if (url
            .contains("https://webapps.bps.go.id/ntt/sso/index.php?state=")) {
          String html = await controller.getHtml();
          Pegawai pegawai = Pegawai.fromHtml(html);
          SavedPreference.savePegawai(pegawai.nip, pegawai.nama, pegawai.foto,
              pegawai.nipBaru, pegawai.email);
          navigateToHome(pegawai: pegawai);
        }
      },
    );
  }

  void navigateToHome({Bidang bidang, Pegawai pegawai}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => bidang != null
                ? AbsensiPage(bidang: bidang)
                : AbsensiPage(pegawai: pegawai)),
        (Route<dynamic> route) => false);
  }
}
