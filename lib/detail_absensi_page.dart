import 'dart:convert';
import 'dart:io';

import 'package:absensi_bps_2/classes/app_util.dart';
import 'package:absensi_bps_2/classes/post_keterangan_absensi.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/laporanharian/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/entri_kegiatan_page.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  double _imageHeight;
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
  AnimationController _animationCheckSignController;
  Animation<double> _animationCheck;
  bool _isSaveLoading = false;
  bool _isDeleteLoading = false;
  bool _isLoadingStatus = true;
  StatusPage _statusPage;
  Future<File> _file;
  String _base64Image = '';
  File _tmpFile;
  String _initialImagePath = '';
  AnimationController _pageAnimationController;

  final _animatedListKey = GlobalKey<SliverAnimatedListState>();

  LaporanHarianBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = LaporanHarianBloc();

    _getAllStatus();

    _animationCheckSignController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _pageAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _pageAnimationController.forward().orCancel;

    _animationCheck = CurvedAnimation(
        parent: _animationCheckSignController, curve: Curves.easeIn);

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
      _initialImagePath = widget.keterangan[0].gambar;
      _animationCheckSignController.forward().orCancel;
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
  void dispose() {
    _animationCheckSignController.dispose();
    _pageAnimationController.dispose();
    _keteranganController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _imageHeight = MediaQuery.of(context).size.height / 4;
    return BlocProvider<LaporanHarianBloc>(
      create: (context) {
        return _bloc
          ..add(GetKegiatanList(widget.pegawai.nip,
              DateFormat("yyyy-MM-dd").format(widget.dateTime)));
      },
      child: BlocBuilder<LaporanHarianBloc, LaporanHarianState>(
        builder: (context, state) {
          return WillPopScope(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Detail Absensi",
                home: Scaffold(
                    key: _scaffoldKey,
                    body: Stack(
                      children: <Widget>[
                        createPage(),
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
                          _onbackPressed(state.listKegiatan.isNotEmpty);
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
                                      ? _deleteFromServer(
                                          new PostKeteranganAbsensi(
                                            datetime:
                                                widget.dateTime.toString(),
                                            nip: widget.pegawai.nip,
                                          ),
                                          state.listKegiatan.isNotEmpty)
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
                                          ? _postToServer(
                                              new PostKeteranganAbsensi(
                                                  datetime: widget.dateTime
                                                      .toString(),
                                                  idstatus: _selectedStatus,
                                                  keterangan:
                                                      _keteranganController
                                                          .text,
                                                  nip: widget.pegawai.nip,
                                                  base64Image: _base64Image,
                                                  fileName: _tmpFile != null
                                                      ? _tmpFile.path
                                                          .split('/')
                                                          .last
                                                      : ""),
                                              state.listKegiatan.isNotEmpty)
                                          : showSnackBar("Sedang Loading")
                                      : showSnackBar("Status Belum Dipilih");
                                },
                                padding: EdgeInsets.only(right: 15),
                              ),
                      ],
                    )),
              ),
              onWillPop: () async {
                _onWillPop(state.listKegiatan.isNotEmpty);
                return true;
              });
        },
      ),
    );
  }

  Future<bool> _onWillPop(bool hasKegiatan) async {
    _onbackPressed(hasKegiatan);
    return true;
  }

  void _navigateToTambahKegiatanPage() async {
    Kegiatan result = await Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, anim1, anim2) {
      return TambahKegiatanPage(
        pegawai: widget.pegawai,
        selectedDateTime: widget.dateTime,
      );
    }));

    if (result != null) {
      _bloc.add(TambahKegiatanHarian(result));
      _animatedListKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 1000));
    }
  }

  void _navigateToEditKegiatanPage(Kegiatan kegiatan) async {
    Kegiatan result = await Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, anim1, anim2) {
      return TambahKegiatanPage(
        pegawai: widget.pegawai,
        selectedDateTime: widget.dateTime,
        kegiatan: kegiatan,
      );
    }));

    if (result != null) {
      _bloc.add(UpdateKegiatanHarian(result));
    }
  }

  Widget createPage() {
    return BlocBuilder<LaporanHarianBloc, LaporanHarianState>(
      builder: (context, state) {
        if (state is LoadingListKegiatan) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ErrorListKegiatan) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () {
                      _bloc.add(GetKegiatanList(widget.pegawai.nip,
                          DateFormat("yyyy-MM-dd").format(widget.dateTime)));
                    },
                    child: Text(
                      "RETRY",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
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
            ),
            SliverToBoxAdapter(
              child: Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 15, left: 20, right: 20),
                child: Text(
                  "Daftar Kegiatan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            BlocConsumer<LaporanHarianBloc, LaporanHarianState>(
              listener: (context, state) {
                if (state is SuccessHapusKegiatan) {
                  Kegiatan kegiatan = state.listKegiatan[state.index];
                  _animatedListKey.currentState.removeItem(
                    state.index,
                    (BuildContext context, Animation<double> animation) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                            parent: animation, curve: Interval(0.5, 1.0)),
                        child: SizeTransition(
                          sizeFactor: CurvedAnimation(
                              parent: animation, curve: Interval(0.0, 1.0)),
                          axisAlignment: 0.0,
                          child: KegiatanItemWidget(
                            kegiatan: kegiatan,
                          ),
                        ),
                      );
                    },
                    duration: Duration(milliseconds: 600),
                  );
                  _bloc.add(FinalHapusKegiatanHarian(state.index, kegiatan.id));
                } else if (state is ErrorHapusKegiatan) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(
                            "Error",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            state.message,
                            style: TextStyle(color: Colors.black54),
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok")),
                          ],
                        );
                      },
                      barrierDismissible: true);
                }
              },
              builder: (context, state) {
                return SliverAnimatedList(
                  key: _animatedListKey,
                  itemBuilder: (context, i, animation) {
                    bool isLoading = false;
                    if (state is LoadingHapusKegiatan) {
                      isLoading = state.index == i;
                    }

                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: CurvedAnimation(
                            parent: animation
                                .drive(Tween<double>(begin: 0.0, end: 1.0)),
                            curve: Interval(0.0, 1.0)),
                        child: KegiatanItemWidget(
                          isLoading: isLoading,
                          kegiatan: state.listKegiatan[i],
                          onEditTap: () async {
                            _navigateToEditKegiatanPage(state.listKegiatan[i]);
                          },
                          onRemoveTap: () {
                            _bloc.add(StartHapusKegiatanHarian(
                                i, state.listKegiatan[i].id));
                          },
                        ),
                      ),
                    );
                  },
                  initialItemCount: state.listKegiatan.length,
                );
              },
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: _navigateToTambahKegiatanPage,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "TAMBAH KEGIATAN",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 15, left: 20, right: 20),
                child: Text(
                  "Absensi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        FadeTranslateContainer(
                          child: Card(
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Column(
                                            children: <Widget>[
                                              Text(
                                                " ",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                " ",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          )),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Column(
                                            children: <Widget>[
                                              Text(
                                                " ",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                " ",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          )),
                                          padding: EdgeInsets.all(10),
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          animation: CurvedAnimation(
                              parent: _pageAnimationController,
                              curve: Interval(
                                0.25,
                                0.5,
                              )),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                padding: EdgeInsets.only(
                                  top: 10,
                                  right: 10,
                                  left: 10,
                                  bottom: 10,
                                ),
                                child: Text(
                                  " ",
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
                                    Hero(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: getAbsenMasukColor(),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 1,
                                                offset:
                                                    Offset.fromDirection(1, 1))
                                          ],
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
                                      tag: (new DateFormat('dd MM yyyy'))
                                              .format(widget.dateTime) +
                                          '0',
                                    ),
                                    Hero(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: getAbsenPulangColor(),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 1,
                                                offset:
                                                    Offset.fromDirection(1, 1))
                                          ],
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
                                      tag: (new DateFormat('dd MM yyyy'))
                                              .format(widget.dateTime) +
                                          '1',
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FadeTranslateContainer(
                      child: Card(
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
                                        child:
                                            ((widget.keterangan.length != 0) |
                                                    (_afterUpdate))
                                                ? FadeTransition(
                                                    opacity: _animationCheck,
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
                                              ? _mapStatus
                                                  .maps[_selectedStatus].id
                                              : null,
                                      underline: _selectedStatus != null
                                          ? Container(
                                              height: 1.0,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color:
                                                              Colors.blueAccent,
                                                          width: 2.0))),
                                            )
                                          : Container(
                                              height: 1.0,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color:
                                                              Color(0xFFBDBDBD),
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
                                        enabledBorder:
                                            _initialKeteranganStatus != null
                                                ? new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.blueAccent,
                                                      width: 2,
                                                    ))
                                                : new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.grey[200],
                                                    ),
                                                  ),
                                        //fillColor: Colors.green
                                      ),
                                      controller: _keteranganController,
                                      maxLines: 3,
                                      validator: (val) {
                                        if (val.length == 0) {
                                          return "Email cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      animation: CurvedAnimation(
                          parent: _pageAnimationController,
                          curve: Interval(
                            0.5,
                            0.75,
                          )),
                    ),
                    FadeTranslateContainer(
                      child: Card(
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
                            widget.keterangan.length == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8),
                                    child: OutlineButton(
                                      onPressed: _chooseImage,
                                      splashColor: splashColor,
                                      child: Text("Pilih Gambar"),
                                    ),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 8),
                              child: widget.keterangan.length == 0
                                  ? _showImage()
                                  : ((_initialImagePath != '') &
                                          (_initialImagePath != null))
                                      ? Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Image.network(
                                              _initialImagePath,
                                              height: _imageHeight,
                                              fit: BoxFit.cover,
                                              semanticLabel: "image",
                                              loadingBuilder:
                                                  (context, widget, chunk) {
                                                if (chunk == null)
                                                  return widget;
                                                return LinearProgressIndicator();
                                              },
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Tidak ada bukti diupload',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      ),
                      animation: CurvedAnimation(
                          parent: _pageAnimationController,
                          curve: Interval(
                            0.75,
                            1.0,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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

  Widget _showImage() {
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
            height: _imageHeight,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.cover,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Gagal mengambil gambar',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Tidak ada gambar dipilih',
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

  void _deleteFromServer(PostKeteranganAbsensi post, bool hasKegiatan) {
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
      _onbackPressed(hasKegiatan);
    });
  }

  void _postToServer(PostKeteranganAbsensi post, bool hasKegiatan) {
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
        _animationCheckSignController.forward();
        _afterUpdate = true;
        _isSaveLoading = false;
      });
      _onbackPressed(hasKegiatan);
    });
  }

  void _onbackPressed(bool hasKegiatan) {
    Navigator.pop(
        context, {"status_page": _statusPage, "has_kegiatan": hasKegiatan});
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
    bool isWeekday = _absenMasuk.dateTime.weekday != DateTime.saturday &&
        _absenMasuk.dateTime.weekday != DateTime.sunday;
    int minute = _absenMasuk.dateTime.minute;
    int hour = _absenMasuk.dateTime.hour;
    int second = _absenMasuk.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (7 * 3600 + 1800)) & (milisec < (9 * 3600)) & isWeekday) {
      return thirdColor;
    } else {
      return firstColor;
    }
  }

  Color getAbsenPulangColor() {
    bool isWeekday = _absenPulang.dateTime.weekday != DateTime.saturday &&
        _absenPulang.dateTime.weekday != DateTime.sunday;
    int minute = _absenPulang.dateTime.minute;
    int hour = _absenPulang.dateTime.hour;
    int second = _absenPulang.dateTime.second;
    int milisec = hour * 3600 + minute * 60 + second;
    if ((milisec > (14 * 3600 + 1800)) & (milisec < (16 * 3600)) & isWeekday) {
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

class FadeTranslateContainer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  FadeTranslateContainer({this.animation, this.child});

  final Tween<double> fadeTween = new Tween(begin: 0.0, end: 1.0);
  final Tween<Offset> offsetTween =
      new Tween(end: Offset.zero, begin: Offset(100, 0));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: offsetTween.evaluate(
              CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
          child: Opacity(
            child: child,
            opacity: fadeTween.evaluate(
                CurvedAnimation(parent: animation, curve: Curves.linear)),
          ),
        );
      },
      child: child,
    );
  }
}

class KegiatanItemWidget extends StatelessWidget {
  final Kegiatan kegiatan;
  final Function onRemoveTap;
  final Function onEditTap;
  final bool isLoading;

  const KegiatanItemWidget(
      {Key key,
      this.onRemoveTap,
      this.kegiatan,
      this.isLoading = false,
      this.onEditTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54, blurRadius: 7, spreadRadius: -5)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        kegiatan.detailKegiatan.nama,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: onEditTap,
                      child: Icon(
                        Icons.edit,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: onRemoveTap,
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Apputil.doubleRemoveZeroTrailing(kegiatan.volume) +
                            " " +
                            kegiatan.detailKegiatan.satuan,
                        style: TextStyle(color: Colors.black38, fontSize: 13),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      (kegiatan.durasi != null && kegiatan.durasi > 0) &&
                              (kegiatan.satuanDurasi != null)
                          ? Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.black38,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Apputil.doubleRemoveZeroTrailing(
                                          kegiatan.durasi) +
                                      " " +
                                      kegiatan.satuanDurasi.nama,
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 13),
                                )
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                kegiatan.statusKegiatan != null
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                "Status Kegiatan: ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(int.parse('0xFF' +
                                          kegiatan.statusKegiatan.color))),
                                  child: Text(
                                    kegiatan.statusKegiatan.status,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                kegiatan.pemberiTugas != null && kegiatan.pemberiTugas != ""
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                "Pemberi Tugas: ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: mainColor),
                                  child: Text(
                                    kegiatan.pemberiTugas,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                kegiatan.keterangan != null && kegiatan.keterangan != ""
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black12, width: 0.5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          kegiatan.keterangan,
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          isLoading ? LinearProgressIndicator() : SizedBox(),
        ],
      ),
    );
  }
}
