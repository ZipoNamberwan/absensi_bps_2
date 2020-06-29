import 'package:absensi_bps_2/laporankegiatan/bloc/pilihkegiatan/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc/pilihkegiatan/pilih_kegiatan_bloc.dart';

class PlihKegiatanPage extends StatefulWidget {
  @override
  _PlihKegiatanPageState createState() => _PlihKegiatanPageState();
}

class _PlihKegiatanPageState extends State<PlihKegiatanPage> {
  PilihKegiatanBloc _bloc;
  TextEditingController _namaController;
  TextEditingController _satuanController;

  @override
  void initState() {
    super.initState();
    _bloc = PilihKegiatanBloc();
    _namaController = TextEditingController();
    _namaController.addListener(() {
      _bloc.add(UpdateNamaKegiatan(_namaController.text));
    });
    _satuanController = TextEditingController();
    _satuanController.addListener(() {
      _bloc.add(UpdateSatuanKegiatan(_satuanController.text));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PilihKegiatanBloc>(
      create: (context) {
        return _bloc..add(GetHistoryKegiatan(""));
      },
      child: BlocBuilder<PilihKegiatanBloc, PilihKegiatanState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                height: MediaQuery.of(context).size.height,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Text(
                              "Nama Kegiatan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black38, width: 0.5)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: TextField(
                                controller: _namaController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Tulis nama kegiatan di sini...",
                                  hintStyle: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Text(
                              "Satuan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black38, width: 0.5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                      child: TextField(
                                        controller: _satuanController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "isi satuan kegiatan...",
                                          hintStyle: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: state.detailKegiatan.isValid()
                                        ? () {}
                                        : () {},
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "SUBMIT",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          opacity:
                                              state.detailKegiatan.isValid()
                                                  ? 0.0
                                                  : 0.5,
                                          child: Container(
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(milliseconds: 300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Kegiatan yang Tersimpan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                      return KegiatanItemWidget(
                        kegiatan: DetailKegiatan.getExampleKegiatan()[i],
                        onTapIcon: () {
                          _namaController.text =
                              DetailKegiatan.getExampleKegiatan()[i].nama;
                          _satuanController.text =
                              DetailKegiatan.getExampleKegiatan()[i].satuan;
                        },
                      );
                    }, childCount: 5)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class KegiatanItemWidget extends StatelessWidget {
  final DetailKegiatan kegiatan;
  final Function onTapIcon;

  const KegiatanItemWidget({Key key, this.kegiatan, this.onTapIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(kegiatan.nama),
                SizedBox(
                  height: 5,
                ),
                Text(
                  kegiatan.satuan,
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTapIcon,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  "images/arrow.svg",
                  width: 12,
                  height: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
