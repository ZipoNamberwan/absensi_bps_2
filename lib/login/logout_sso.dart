import 'package:absensi_bps_2/classes/shared_preference.dart';
import 'package:absensi_bps_2/login/login_sso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LogOutSSO extends StatefulWidget {
  @override
  _LogOutSSOState createState() => _LogOutSSOState();
}

class _LogOutSSOState extends State<LogOutSSO> {
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrl:
          "https://sso.bps.go.id/auth/realms/pegawai-bps/protocol/openid-connect/logout?redirect_uri=https://webapps.bps.go.id/ntt/sso/index.php/welcome/logout",
      onLoadStop: (controller, url) async {
        if (url ==
            "https://webapps.bps.go.id/ntt/sso/index.php/welcome/logout") {
          await SavedPreference.removeAll();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoginSSO();
          }));
        }
      },
    );
  }
}
