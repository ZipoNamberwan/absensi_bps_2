import 'package:absensi_bps_2/laporankegiatan/tambah_kegiatan.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:flutter/material.dart';

class EntriLaporanHarianPage extends StatefulWidget {
  @override
  _EntriLaporanHarianPageState createState() => _EntriLaporanHarianPageState();
}

class _EntriLaporanHarianPageState extends State<EntriLaporanHarianPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        backgroundColor: mainColor,
        title: Text(
          "Entri Laporan Kegiatan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                "Tanggal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black38, width: 0.5)),
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(bottom: 15),
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
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                "Daftar Kegiatan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TambahKegiatanPage();
                }));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(10)),
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
            )
          ],
        ),
      ),
    );
  }
}
