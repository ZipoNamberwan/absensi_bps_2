import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_bloc.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_event.dart';
import 'package:absensi_bps_2/laporankegiatan/bloc/entrikegiatan/entri_kegiatan_state.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/pilih_kegiatan_page.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambahKegiatanPage extends StatefulWidget {
  @override
  _TambahKegiatanPageState createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  EntriKegiatanBloc _bloc;
  TextEditingController _volumeContorller;
  TextEditingController _durasiController;
  TextEditingController _pemberiTugasController;

  @override
  void initState() {
    super.initState();
    _bloc = EntriKegiatanBloc();
    _volumeContorller = TextEditingController();
    _volumeContorller.addListener(() {
      double volume = 0;
      try {
        volume = double.parse(_volumeContorller.text);
      } catch (e) {}
      _bloc.add(UpdateVolumeKegiatan(volume));
    });
    _durasiController = TextEditingController();
    _durasiController.addListener(() {
      double durasi = 0;
      try {
        durasi = double.parse(_durasiController.text);
      } catch (e) {}
      _bloc.add(UpdateDurasiKegiatan(durasi));
    });
    _pemberiTugasController = TextEditingController();
    _pemberiTugasController.addListener(() {
      _bloc.add(UpdatePemberiTugasKegiatan(_pemberiTugasController.text));
    });
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
        return _bloc;
      },
      child: BlocBuilder<EntriKegiatanBloc, EntriKegiatanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              backgroundColor: mainColor,
              title: Text(
                "Tambah Kegiatan",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                        DetailKegiatan result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PlihKegiatanPage();
                        }));

                        if (result != null) {
                          _bloc.add(UpdateDetailKegiatan(result));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black38, width: 0.5)),
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
                                          ? state.kegiatan.detailKegiatan.nama
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
                                    child: DropdownButton<String>(
                                      onChanged: (value) {
                                        _bloc.add(
                                            UpdateSatuanDurasiKegiatan(value));
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
                                      items: [
                                        DropdownMenuItem(
                                          value: "Menit",
                                          child: Text("Menit"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Jam",
                                          child: Text("Jam"),
                                        ),
                                        DropdownMenuItem(
                                          value: "hari",
                                          child: Text("Hari"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Bulan",
                                          child: Text("Bulan"),
                                        ),
                                      ],
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
                          border:
                              Border.all(color: Colors.black38, width: 0.5)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 25),
                      child: Center(
                        child: TextField(
                          controller: _pemberiTugasController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Tulis nama pemberi tugas di sini",
                            hintStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: state.kegiatan.isValid()
                            ? () {
                                Navigator.pop(context, state.kegiatan);
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
                                  "TAMBAH",
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
                        ))
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
