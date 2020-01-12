import 'dart:convert';
import 'dart:io';

import 'package:absensi_bps_2/classes/post_keterangan_absensi.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'api/api_custom.dart';
import 'classes/detail_absensi.dart';
import 'classes/event_list.dart';
import 'classes/keterangan_absensi.dart';

class DetailAbsensiPage extends StatefulWidget {
  final DateTime dateTime;
  final List<DetailAbsensi> details;
  final List<KeteranganAbsensi> keterangan;
  final Pegawai pegawai;

  DetailAbsensiPage(
      {this.dateTime, this.details, this.keterangan, this.pegawai});

  @override
  State<StatefulWidget> createState() => new _DetailAbsensiState();
}

class _DetailAbsensiState extends State<DetailAbsensiPage>
    with TickerProviderStateMixin {
  MapList<Status> _mapStatus = new MapList();
  DetailAbsensi _absenMasuk = new DetailAbsensi();
  DetailAbsensi _absenPulang = new DetailAbsensi();
  String _selectedStatus;
  String _initialKeteranganStatus;
  Status _postedStatus;
  String _postedKeterangan;
  TextEditingController _keteranganController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _afterUpdate = false;
  AnimationController _animationController;
  Animation<double> _animation;
  bool _isSaveLoading = false;
  bool _isDeleteLoading = false;
  bool _isLoadingStatus = true;
  StatusPage _statusPage;
  Future<File> _file;
  String _base64Image = '';
  File _tmpFile;

  @override
  void initState() {
    super.initState();
    _getAllStatus();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    if (widget.details.length == 0) {
      _absenMasuk = new DetailAbsensi(dateTime: widget.dateTime, time: "-");
      _absenPulang = new DetailAbsensi(dateTime: widget.dateTime, time: "-");
    } else {
      _absenMasuk = widget.details[0];
      _absenPulang = widget.details[widget.details.length - 1];
    }
    if (widget.keterangan.length != 0) {
      _selectedStatus = widget.keterangan[0].status.id;
      _initialKeteranganStatus = widget.keterangan[0].keterangan;
      _animationController.forward();
    }

    _keteranganController = new TextEditingController(
        text:
            _initialKeteranganStatus != null ? _initialKeteranganStatus : null);

    _statusPage = new StatusPage(
        status: StatusPage.noPost,
        keteranganAbsensi: null,
        dateTime: widget.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Detail Absensi",
          home: Scaffold(
              key: _scaffoldKey,
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child:
                        // your body code
                        createPage(),
                  ),
                  (_isSaveLoading | _isDeleteLoading)
                      ? LinearProgressIndicator()
                      : Container(),
                ],
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    _onbackPressed();
                  },
                ),
                title: Text(
                  widget.pegawai.nama,
                  style: TextStyle(color: Colors.black87),
                ),
                elevation: 0,
                actions: <Widget>[
                  widget.keterangan.length > 0
                      ? IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            !_isDeleteLoading
                                ? _deleteFromServer(new PostKeteranganAbsensi(
                                    datetime: widget.dateTime.toString(),
                                    nip: widget.pegawai.nip,
                                  ))
                                : showSnackBar("Sedang Loading");
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.save,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            _selectedStatus != null
                                ? !_isSaveLoading
                                    ? _postToServer(new PostKeteranganAbsensi(
                                        datetime: widget.dateTime.toString(),
                                        idstatus: _selectedStatus,
                                        keterangan: _keteranganController.text,
                                        nip: widget.pegawai.nip,
                                        base64Image: _base64Image,
                                        fileName: _tmpFile != null
                                            ? _tmpFile.path.split('/').last
                                            : ""))
                                    : showSnackBar("Sedang Loading")
                                : showSnackBar("Status Belum Dipilih");
                          },
                          padding: EdgeInsets.only(right: 15),
                        ),
                ],
              )),
        ),
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() {
    _onbackPressed();
  }

  Widget createPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Center(
                child: Text(
                  DateFormat.yMMMMd("id").format(widget.dateTime),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        "Waktu datang dan pulang",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: getAbsenMasukColor(),
                            ),
                            child: Center(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  _absenMasuk.time,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "datang",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            )),
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: getAbsenPulangColor(),
                            ),
                            child: Center(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  _absenPulang.time,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "pulang",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            )),
                            padding: EdgeInsets.all(10),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Keterangan Absensi",
                            style: TextStyle(fontSize: 11),
                          ),
                          Spacer(),
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: ((widget.keterangan.length != 0) |
                                      (_afterUpdate))
                                  ? FadeTransition(
                                      opacity: _animation,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blueAccent,
                                        size: 20,
                                      ))
                                  : null),
                          _isLoadingStatus
                              ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  width: 15,
                                  height: 15,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          DropdownButton<String>(
                            items: _mapStatus.maps != null
                                ? _createDropdownItems()
                                : [],
                            onChanged: (idstatus) {
                              setState(() {
                                _selectedStatus = idstatus;
                              });
                            },
                            isExpanded: true,
                            value: _mapStatus.maps == null
                                ? null
                                : _selectedStatus != null
                                    ? _mapStatus.maps[_selectedStatus].id
                                    : null,
                            underline: _selectedStatus != null
                                ? Container(
                                    height: 1.0,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0))),
                                  )
                                : Container(
                                    height: 1.0,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xFFBDBDBD),
                                                width: 0.0))),
                                  ),
                            hint: Text(
                              "Status Absensi...",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Isi keterangan...",
                              labelStyle: TextStyle(fontSize: 14),
                              fillColor: Colors.white,
                              isDense: true,
                              enabledBorder: _initialKeteranganStatus != null
                                  ? new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(
                                        color: Colors.blueAccent,
                                        width: 2,
                                      ))
                                  : new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(
                                        color: Colors.grey[200],
                                      ),
                                    ),
                              //fillColor: Colors.green
                            ),
                            controller: _keteranganController,
                            maxLines: 3,
                            /*validator: (val) {
                            if (val.length == 0) {
                              return "Email cannot be empty";
                            } else {
                              return null;
                            }
                          },*/
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      "Bukti",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: OutlineButton(
                      onPressed: _chooseImage,
                      splashColor: splashColor,
                      child: Text("Choose Image"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 16),
                    child: showImage(),
                  ),
                  /*OutlineButton(
                    child: Text("Upload now"),
                    onPressed: () {
                      _startUpload();
                    },
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _file =
                            ImagePicker.pickImage(source: ImageSource.camera);
                      });
                    },
                    splashColor: splashColor,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_camera,
                      ),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _file =
                            ImagePicker.pickImage(source: ImageSource.gallery);
                      });
                    },
                    splashColor: splashColor,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                      ),
                      title: Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: _file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          _tmpFile = snapshot.data;
          _base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            height: MediaQuery.of(context).size.height / 4,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.cover,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  _createDropdownItems() {
    List<DropdownMenuItem<String>> tmp = [];
    _mapStatus.maps.forEach((id, status) => tmp.add(DropdownMenuItem<String>(
        child: Text(
          status.status,
          style: TextStyle(fontSize: 14),
        ),
        value: id)));
    return tmp;
  }

  bool _getAllStatus() {
    ApiCustom.getStatus().then((response) {
      var jsonResponse = jsonDecode(response.body);
      StatusList list = StatusList.fromJson(jsonResponse);
      list.list.forEach((status) => _mapStatus.add(status.id, status));
      setState(() {
        _isLoadingStatus = false;
      });
      return true;
    });
    return false;
  }

  void _deleteFromServer(PostKeteranganAbsensi post) {
    setState(() {
      _isSaveLoading = true;
    });
    ApiCustom.deletePost(post).then((response) {
      showSnackBar("Sudah di hapus");
      setState(() {
        _isSaveLoading = false;
        _statusPage = new StatusPage(
            status: StatusPage.afterDelete,
            keteranganAbsensi: null,
            dateTime: widget.dateTime);
      });
      _onbackPressed();
    });
  }

  void _postToServer(PostKeteranganAbsensi post) {
    setState(() {
      _isSaveLoading = true;
    });
    ApiCustom.createPost(post).then((response) {
      showSnackBar("Sudah di set");
      _postedKeterangan = post.keterangan;
      _postedStatus = _mapStatus.maps[post.idstatus];

      setState(() {
        _statusPage = new StatusPage(
          status: StatusPage.afterPost,
          keteranganAbsensi: new KeteranganAbsensi(
              pegawai: widget.pegawai,
              status: _postedStatus,
              keterangan: _postedKeterangan,
              dateTime: widget.dateTime,
              gambar: response.bukti),
          dateTime: widget.dateTime,
        );
        _animationController.forward();
        _afterUpdate = true;
        _isSaveLoading = false;

      });
      _onbackPressed();
    });
  }

  void _onbackPressed() {
    Navigator.pop(context, _statusPage);
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

  Color getAbsenMasukColor() {
    int minute = _absenMasuk.dateTime.minute;
    int hour = _absenMasuk.dateTime.hour;
    int second = _absenMasuk.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (7 * 3600 + 1800)) & (milisec < (9 * 3600))) {
      return thirdColor;
    } else {
      return firstColor;
    }
  }

  getAbsenPulangColor() {
    int minute = _absenPulang.dateTime.minute;
    int hour = _absenPulang.dateTime.hour;
    int second = _absenPulang.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (14 * 3600 + 1800)) & (milisec < (16 * 3600))) {
      return thirdColor;
    } else {
      return secondColor;
    }
  }
}

class StatusPage {
  static final String noPost = "no post";
  static final String afterPost = "after post";
  static final String afterDelete = "after delete";

  String status;
  KeteranganAbsensi keteranganAbsensi;
  DateTime dateTime;

  StatusPage({this.status, this.keteranganAbsensi, this.dateTime});
}
