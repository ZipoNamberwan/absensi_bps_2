import 'package:absensi_bps_2/classes/app_util.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/laporanharian/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/tambah_kegiatan.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntriLaporanHarianPage extends StatefulWidget {
  @override
  _EntriLaporanHarianPageState createState() => _EntriLaporanHarianPageState();
}

class _EntriLaporanHarianPageState extends State<EntriLaporanHarianPage> {
  final _animatedListKey = GlobalKey<SliverAnimatedListState>();

  LaporanHarianBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LaporanHarianBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaporanHarianBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocBuilder<LaporanHarianBloc, LaporanHarianState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              backgroundColor: mainColor,
              title: Text(
                "Entri Laporan Kegiatan",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 15, top: 32, right: 20, left: 20),
                    child: Text(
                      "Tanggal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12, width: 0.5)),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    child: TextField(
                      decoration: InputDecoration(
                          enabled: false,
                          border: InputBorder.none,
                          hintText: "dd/mm/yyyy",
                          hintStyle: TextStyle(fontSize: 12),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.black54,
                            size: 23,
                          )),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    child: Text(
                      "Daftar Kegiatan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverAnimatedList(
                    key: _animatedListKey,
                    itemBuilder: (context, i, animation) {
                      return KegiatanItemWidget(
                        kegiatan: state.listKegiatan[i],
                      );
                    },
                    initialItemCount: state.listKegiatan.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: GestureDetector(
                  onTap: () async {
                    Kegiatan result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TambahKegiatanPage();
                    }));

                    if (result != null) {
                      _bloc.add(TambahKegiatanHarian(result));
                      _animatedListKey.currentState.insertItem(
                          state.listKegiatan.length,
                          duration: Duration(milliseconds: 300));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
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
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}

class KegiatanItemWidget extends StatelessWidget {
  final Kegiatan kegiatan;

  const KegiatanItemWidget({Key key, this.kegiatan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: -5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kegiatan.detailKegiatan.nama,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Icon(
                Icons.remove_circle,
                color: Colors.red,
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
            margin: EdgeInsets.only(bottom: 10),
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
                Row(
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
                      Apputil.doubleRemoveZeroTrailing(kegiatan.durasi) +
                          " " +
                          kegiatan.satuanDurasi,
                      style: TextStyle(color: Colors.black38, fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pemberi Tugas: ",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: mainColor, borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    kegiatan.pemberiTugas,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 0.5)),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Keterangan pekerjaan jika ada...",
                  hintStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
