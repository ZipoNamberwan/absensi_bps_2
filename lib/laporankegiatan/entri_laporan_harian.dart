import 'package:absensi_bps_2/classes/app_util.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/laporanharian/bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/tambah_kegiatan.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

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
                  child: GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1), onConfirm: (date) {
                        _bloc.add(UpdateTanggalLaporanHarian(date));
                      },
                          currentTime: state.laporanHarian.tanggal != null
                              ? state.laporanHarian.tanggal
                              : DateTime.now(),
                          locale: LocaleType.id);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.black12, width: 0.5)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                      child: TextField(
                        controller: TextEditingController(
                            text: state.laporanHarian.tanggal != null
                                ? DateFormat('EEE, d MMM yyyy')
                                    .format(state.laporanHarian.tanggal)
                                : ""),
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
                state.laporanHarian.listKegiatan.length > 0
                    ? SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: _navigateToTambahKegiatanPage,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 10, right: 20, left: 20),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 10,
                                    spreadRadius: -5)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: mainColor,
                                    dashPattern: [6, 6, 6, 6],
                                    radius: Radius.circular(8),
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "TAMBAH KEGIATAN",
                                  style:
                                      TextStyle(color: mainColor, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: SizedBox(),
                      ),
                SliverAnimatedList(
                  key: _animatedListKey,
                  itemBuilder: (context, i, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: CurvedAnimation(
                            parent: animation
                                .drive(Tween<double>(begin: 0.0, end: 1.0)),
                            curve: Interval(0.0, 1.0)),
                        child: KegiatanItemWidget(
                          kegiatan: state.laporanHarian.listKegiatan[i],
                          onRemoveTap: () {
                            /*Kegiatan kegiatan =
                                  state.laporanHarian.listKegiatan.removeAt(i);*/
                            Kegiatan kegiatan =
                                state.laporanHarian.listKegiatan[i];
                            _animatedListKey.currentState.removeItem(
                              i,
                              (BuildContext context,
                                  Animation<double> animation) {
                                return FadeTransition(
                                  opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Interval(0.5, 1.0)),
                                  child: SizeTransition(
                                    sizeFactor: CurvedAnimation(
                                        parent: animation,
                                        curve: Interval(0.0, 1.0)),
                                    axisAlignment: 0.0,
                                    child: KegiatanItemWidget(
                                      kegiatan: kegiatan,
                                      onRemoveTap: () {},
                                    ),
                                  ),
                                );
                              },
                              duration: Duration(milliseconds: 600),
                            );
                            _bloc.add(HapusKegiatanHarian(i));
                          },
                        ),
                      ),
                    );
                  },
                  initialItemCount: state.laporanHarian.listKegiatan.length,
                ),
                SliverToBoxAdapter(
                    child: state.laporanHarian.listKegiatan.isEmpty
                        ? GestureDetector(
                            onTap: _navigateToTambahKegiatanPage,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
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
                          )
                        : GestureDetector(
                            onTap: state.laporanHarian.isValid()
                                ? _submitlaporanHarian(state.laporanHarian)
                                : () {},
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20, top: 10),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(10)),
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
                                      state.laporanHarian.isValid() ? 0.0 : 0.5,
                                  duration: Duration(milliseconds: 300),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 20,
                                        top: 10),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ))
              ],
            ),
          );
        },
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

  _submitlaporanHarian(LaporanHarian laporanHarian) {}
}

class KegiatanItemWidget extends StatelessWidget {
  final Kegiatan kegiatan;
  final Function onRemoveTap;

  const KegiatanItemWidget({Key key, this.onRemoveTap, this.kegiatan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
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
                                  kegiatan.satuanDurasi,
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 13),
                            )
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            kegiatan.pemberiTugas != null && kegiatan.pemberiTugas != ""
                ? Container(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            kegiatan.pemberiTugas,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
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
      ),
    );
  }
}
