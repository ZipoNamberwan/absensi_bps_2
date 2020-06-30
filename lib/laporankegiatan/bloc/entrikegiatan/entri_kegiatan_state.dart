import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class EntriKegiatanState {
  final Kegiatan kegiatan;

  EntriKegiatanState({this.kegiatan});
}

class InitialEntriKegiatanState extends EntriKegiatanState {
  InitialEntriKegiatanState()
      : super(kegiatan: Kegiatan(detailKegiatan: DetailKegiatan(), satuanDurasi: "Menit"));
}
