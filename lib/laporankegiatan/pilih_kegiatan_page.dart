import 'package:absensi_bps_2/classes/keterangan_absensi.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/pilihkegiatan/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc/pilihkegiatan/pilih_kegiatan_bloc.dart';

class PlihKegiatanPage extends StatefulWidget {
  final Pegawai pegawai;

  const PlihKegiatanPage({Key key, this.pegawai}) : super(key: key);

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
    _satuanController = TextEditingController();
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
        return _bloc..add(GetHistoryKegiatan(widget.pegawai.nip, ""));
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
                                onChanged: (value) {
                                  _bloc.add(UpdateNamaKegiatan(
                                      widget.pegawai.nip, value));
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _namaController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "Tulis atau cari kegiatan di sini...",
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
                                        onChanged: (value) {
                                          _bloc
                                              .add(UpdateSatuanKegiatan(value));
                                        },
                                        textCapitalization:
                                            TextCapitalization.sentences,
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
                                        ? () {
                                            Navigator.pop(
                                                context, state.detailKegiatan);
                                          }
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
                    BlocBuilder<PilihKegiatanBloc, PilihKegiatanState>(
                      builder: (context, state) {
                        if (state is LoadingHistoryKegiatan) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        } else if (state is ErrorHistoryKegiatan) {
                          return SliverToBoxAdapter(
                            child: Container(
                              child: Column(
                                children: [
                                  Text(state.message),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _bloc.add(GetHistoryKegiatan(
                                          widget.pegawai.nip, ""));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        "RETRY",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        if (state.listHistoryKegiatan.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Container(
                              child: Text("Belum ada history kegiatan"),
                            ),
                          );
                        } else {
                          return SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, i) {
                            return HistoryKegiatanItemWidget(
                              detailKegiatan: state.listHistoryKegiatan[i],
                              onTapIcon: () {
                                _namaController.text =
                                    state.listHistoryKegiatan[i].nama;
                                _satuanController.text =
                                    state.listHistoryKegiatan[i].satuan;

                                _bloc.add(UpdateNamaKegiatan(
                                    widget.pegawai.nip, _namaController.text));
                                _bloc.add(UpdateSatuanKegiatan(
                                    _satuanController.text));
                              },
                            );
                          }, childCount: state.listHistoryKegiatan.length));
                        }
                      },
                    ),
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

class HistoryKegiatanItemWidget extends StatelessWidget {
  final DetailKegiatan detailKegiatan;
  final Function onTapIcon;

  const HistoryKegiatanItemWidget(
      {Key key, this.detailKegiatan, this.onTapIcon})
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
            child: InkWell(
              onTap: () {
                Navigator.pop(context, detailKegiatan);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(detailKegiatan.nama),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    detailKegiatan.satuan,
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 2,
            child: InkWell(
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
