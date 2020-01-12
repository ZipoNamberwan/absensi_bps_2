import 'dart:convert';

import 'package:absensi_bps_2/classes/bidang.dart';
import 'package:absensi_bps_2/classes/keterangan_absensi.dart';
import 'package:absensi_bps_2/classes/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bps_2/src/default_styles.dart';

import '../api/api_custom.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static final String pegawaiTypeLogin = "pegawai";
  static final String bidangTypeLogin = "bidang";

  TextStyle style = TextStyle(fontSize: 15.0);
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPreparing = true;
  bool _isloginLoading = false;
  String _idLoginType = pegawaiTypeLogin;

  @override
  void initState() {
    super.initState();
    _isPreparing = true;
    SavedPreference.getLogInData().then((data) {
      if (data != null) {
        navigateToHome(
            bidang: data is Bidang ? data : null,
            pegawai: data is Pegawai ? data : null);
      } else {
        setState(() {
          _isPreparing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          hintStyle: loginHintTextStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          hintStyle: loginHintTextStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final loginButon = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color.fromRGBO(62, 134, 243, 100),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_idLoginType == bidangTypeLogin)
            loginBidang(usernameController.text, passwordController.text);
          else
            loginPegawai(usernameController.text, passwordController.text);
        },
        child: SizedBox(
          height: 25,
          child: !_isloginLoading
              ? Center(
                  child: Text("Login",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              : SizedBox(
                  child: CircularProgressIndicator(),
                  width: 25,
                ),
        ),
      ),
    );

    final DropdownButton dropdownButton = DropdownButton<String>(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
            child: Text(
              "Pegawai",
              style: TextStyle(fontSize: 14),
            ),
            value: pegawaiTypeLogin),
        DropdownMenuItem<String>(
            child: Text(
              "Bidang",
              style: TextStyle(fontSize: 14),
            ),
            value: bidangTypeLogin),
      ],
      value: _idLoginType,
      isDense: true,
      onChanged: (id) {
        _idLoginType = id;
        setState(() {});
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: _isPreparing
            ? LinearProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              height: 155.0,
                              child: Icon(
                                Icons.date_range,
                                size: 100,
                              ) /*Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),*/
                              ),
                          Text(
                            "Absensi BPS Prov NTT",
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Jenis Login",
                                  style: loginHintTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                dropdownButton,
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0),
                          usernameField,
                          SizedBox(height: 15.0),
                          passwordField,
                          SizedBox(
                            height: 20.0,
                          ),
                          loginButon,
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void loginBidang(String username, String password) {
    setState(() {
      _isloginLoading = true;
    });
    ApiCustom.loginBidang(username, password).then((response) {
      var jsonresponse = jsonDecode(response.body);
      BidangList list = BidangList.fromJson(jsonresponse);
      if (list.list.length > 0) {
        Bidang bidang = list.list[0];
        SavedPreference.saveBidang(
            bidang.id, bidang.namabidang, bidang.username, bidang.password);
        navigateToHome(bidang: bidang);
      } else {
        showSnackBar("Username password salah");
      }
      setState(() {
        _isloginLoading = false;
      });
    }).catchError((onError) {
      showSnackBar("Something went wrong, we are gonna fix this vary soon");
      setState(() {
        _isloginLoading = false;
      });
    });
  }

  void loginPegawai(String username, String password) {
    setState(() {
      _isloginLoading = true;
    });

    ApiCustom.loginPegawai(username, password).then((response) {
      var jsonresponse = jsonDecode(response);
      PegawaiList list = PegawaiList.fromJson(jsonresponse);
      if (list.list.length > 0) {
        Pegawai pegawai = list.list[0];
        SavedPreference.savePegawai(pegawai.nip, pegawai.nama, pegawai.foto,
            pegawai.nipBaru, pegawai.email);
        navigateToHome(pegawai: pegawai);
      }
      setState(() {
        _isloginLoading = false;
      });
    }).catchError((onError) {
      showSnackBar("Username Password salah");
      setState(() {
        _isloginLoading = false;
      });
    });
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

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 700),
        content: Row(
          children: <Widget>[
            Container(
              child: Icon(
                Icons.warning,
                size: 15,
              ),
              margin: EdgeInsets.only(right: 5),
            ),
            Text(
              message,
              style: TextStyle(fontSize: 15),
            )
          ],
        )));
  }
}
