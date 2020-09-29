import 'package:absensi_bps_2/classes/keterangan_absensi.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_event.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_state.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/pilih_kegiatan_page.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TambahKegiatanPage extends StatefulWidget {
  final Kegiatan kegiatan;
  final DateTime selectedDateTime;
  final Pegawai pegawai;

  const TambahKegiatanPage(
      {Key key, this.kegiatan, this.pegawai, this.selectedDateTime})
      : super(key: key);

  @override
  _TambahKegiatanPageState createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  EntriKegiatanBloc _bloc;
  TextEditingController _volumeContorller;
  TextEditingController _durasiController;
  TextEditingController _pemberiTugasController;
  TextEditingController _keteranganController;

  @override
  void initState() {
    super.initState();
    _bloc = EntriKegiatanBloc();
    _volumeContorller = TextEditingController(
        text:
            widget.kegiatan != null ? widget.kegiatan.volume.toString() : null);
    _volumeContorller.addListener(() {
      double volume = 0;
      try {
        volume = double.parse(_volumeContorller.text);
      } catch (e) {}
      _bloc.add(UpdateVolumeKegiatan(volume));
    });
    _durasiController = TextEditingController(
        text: widget.kegiatan != null
            ? widget.kegiatan.durasi != null
                ? widget.kegiatan.durasi.toString()
                : null
            : null);
    _durasiController.addListener(() {
      double durasi = 0;
      try {
        durasi = double.parse(_durasiController.text);
      } catch (e) {}
      _bloc.add(UpdateDurasiKegiatan(durasi));
    });
    _pemberiTugasController = TextEditingController(
        text: widget.kegiatan != null
            ? widget.kegiatan.pemberiTugas != null
                ? widget.kegiatan.pemberiTugas
                : null
            : null);
    _pemberiTugasController.addListener(() {
      _bloc.add(UpdatePemberiTugasKegiatan(_pemberiTugasController.text));
    });

    _keteranganController = TextEditingController(
        text: widget.kegiatan != null
            ? widget.kegiatan.keterangan != null
                ? widget.kegiatan.keterangan
                : null
            : null);
    _keteranganController.addListener(() {
      _bloc.add(UpdateKeterangan(_keteranganController.text));
    });
    /*if (widget.selectedDateTime != null) {
      _bloc.add(UpdateTanggal(widget.selectedDateTime));
    }*/
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntriKegiatanBloc>(
      create: (context) {
        return _bloc..add(InitPage(widget.kegiatan, widget.selectedDateTime));
      },
      child: BlocConsumer<EntriKegiatanBloc, EntriKegiatanState>(
        listener: (context, state) {
          if (state is SuccessPost) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      "Sukses",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      "Kegiatan sudah disimpan",
                      style: TextStyle(color: Colors.black54),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context, state.kegiatan);
                            Navigator.pop(context, state.kegiatan);
                          },
                          child: Text("OK")),
                    ],
                  );
                },
                barrierDismissible: false);
          } else if (state is ErrorInitEntriKegiatanState) {
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
                            Navigator.pop(context);
                          },
                          child: Text("OK")),
                    ],
                  );
                },
                barrierDismissible: false);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: mainColor,
                  title: Text(
                    "Tambah Kegiatan",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Tanggal *",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.selectedDateTime != null
                              ? () {}
                              : () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2019, 1, 1),
                                      onConfirm: (date) {
                                    _bloc.add(UpdateTanggal(date));
                                  },
                                      currentTime:
                                          state.kegiatan.tanggal != null
                                              ? state.kegiatan.tanggal
                                              : DateTime.now(),
                                      locale: LocaleType.id);
                                },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black12, width: 0.5)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(bottom: 15),
                            child: TextField(
                              controller: TextEditingController(
                                  text: widget.selectedDateTime != null
                                      ? DateFormat("yyyy-MM-dd")
                                          .format(widget.selectedDateTime)
                                      : state.kegiatan.tanggal != null
                                          ? DateFormat('EEE, d MMM yyyy')
                                              .format(state.kegiatan.tanggal)
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
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Kegiatan *",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DetailKegiatan result = await Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return PlihKegiatanPage(
                                pegawai: widget.pegawai,
                              );
                            }));

                            if (result != null) {
                              _bloc.add(UpdateDetailKegiatan(result));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black38, width: 0.5)),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(bottom: 15),
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: state.kegiatan.detailKegiatan
                                                  .isValid()
                                              ? state
                                                  .kegiatan.detailKegiatan.nama
                                              : ""),
                                      decoration: InputDecoration(
                                        enabled: false,
                                        border: InputBorder.none,
                                        hintText: "Pilih/Tambah Kegiatan",
                                        hintStyle: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "images/next.svg",
                                    width: 22,
                                    height: 22,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Volume *",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 65,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black38, width: 0.5)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: TextField(
                                    controller: _volumeContorller,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (value) {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                state.kegiatan.detailKegiatan.isValid()
                                    ? state.kegiatan.detailKegiatan.satuan
                                    : "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Durasi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 65,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black38, width: 0.5)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: TextField(
                                    controller: _durasiController,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (value) {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black38, width: 0.5)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButton<SatuanDurasi>(
                                          onChanged: (value) {
                                            _bloc.add(
                                                UpdateSatuanDurasiKegiatan(
                                                    value));
                                            FocusScope.of(context).nextFocus();
                                          },
                                          value: state.kegiatan.satuanDurasi,
                                          underline: SizedBox(),
                                          isExpanded: true,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: mainColor,
                                            size: 30,
                                          ),
                                          items: state.listSatuanDurasi
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.nama),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Pemberi Tugas",
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
                              controller: _pemberiTugasController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tulis nama pemberi tugas di sini",
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Status Kegiatan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 2 / 3,
                          margin: EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black38, width: 0.5)),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButton<StatusKegiatan>(
                                    onChanged: (value) {
                                      _bloc.add(UpdateStatusKegiatan(value));
                                      FocusScope.of(context).nextFocus();
                                    },
                                    value: state.kegiatan.statusKegiatan,
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: mainColor,
                                      size: 30,
                                    ),
                                    items: state.listStatusKegiatan
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.status),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Keterangan",
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
                              maxLines: 4,
                              controller: _keteranganController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tulis keterangan jika ada",
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: state.kegiatan.isValid()
                                ? () {
                                    widget.kegiatan == null
                                        ? _bloc.add(
                                            PostKegiatan(widget.pegawai.nip))
                                        : _bloc.add(PostEditKegiatan(
                                            widget.pegawai.nip));
                                  }
                                : () {},
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      widget.kegiatan == null
                                          ? "TAMBAH"
                                          : "SIMPAN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: state.kegiatan.isValid() ? 0.0 : 0.5,
                                  child: Container(
                                    height: 50,
                                    color: Colors.white,
                                  ),
                                  duration: Duration(milliseconds: 300),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              state is InitialEntriKegiatanState || state is LoadingPost
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black54.withOpacity(0.5),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox()
            ],
          );
        },
      ),
    );
  }
}
