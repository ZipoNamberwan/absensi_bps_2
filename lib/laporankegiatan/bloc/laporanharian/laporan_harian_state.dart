import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class LaporanHarianState {
  final String tanggal;
  final List<Kegiatan> listKegiatan;

  LaporanHarianState({this.tanggal, this.listKegiatan});

  LaporanHarianState copyWith({String tanggal, List<Kegiatan> listKegiatan}) {
    return LaporanHarianState(
        tanggal: tanggal ?? this.tanggal,
        listKegiatan: listKegiatan ?? this.listKegiatan);
  }
}

class InitialLaporanHarianState extends LaporanHarianState {
  InitialLaporanHarianState() : super(listKegiatan: List<Kegiatan>());
}
