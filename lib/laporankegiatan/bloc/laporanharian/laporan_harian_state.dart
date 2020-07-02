import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class LaporanHarianState {
  final LaporanHarian laporanHarian;

  LaporanHarianState({this.laporanHarian});
}

class InitialLaporanHarianState extends LaporanHarianState {
  InitialLaporanHarianState()
      : super(laporanHarian: LaporanHarian(listKegiatan: List<Kegiatan>()));
}
