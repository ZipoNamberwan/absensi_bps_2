import 'package:absensi_bps_2/classes/app_util.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/laporanharian/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/entri_kegiatan_page.dart';
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
        return _bloc..add(GetKegiatanList("57639", "2020-07-22"));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          backgroundColor: mainColor,
          title: Text(
            "View Laporan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: BlocBuilder<LaporanHarianBloc, LaporanHarianState>(
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
                          _bloc.add(GetKegiatanList("57639", "2020-07-22"));
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
                    margin: EdgeInsets.only(
                        top: 30, bottom: 15, left: 20, right: 20),
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
                      _bloc.add(
                          FinalHapusKegiatanHarian(state.index, kegiatan.id));
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
                                Kegiatan result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TambahKegiatanPage(
                                    kegiatan: state.listKegiatan[i],
                                  );
                                }));

                                if (result != null) {
                                  _bloc.add(UpdateKegiatanHarian(result));
                                }
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
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToTambahKegiatanPage() async {
    Kegiatan result = await Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, anim1, anim2) {
      return TambahKegiatanPage();
    }));

    if (result != null) {
      _bloc.add(TambahKegiatanHarian(result));
      _animatedListKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 1000));
    }
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
                      kegiatan.durasi != null && kegiatan.durasi > 0
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
