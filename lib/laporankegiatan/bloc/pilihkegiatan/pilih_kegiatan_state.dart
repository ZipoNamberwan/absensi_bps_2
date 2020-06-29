import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class PilihKegiatanState {
  final DetailKegiatan detailKegiatan;

  PilihKegiatanState({this.detailKegiatan});
}

class InitialPilihKegiatanState extends PilihKegiatanState {
  InitialPilihKegiatanState() : super(detailKegiatan: DetailKegiatan());
}

class LoadingHistoryKegiatan extends PilihKegiatanState {
  LoadingHistoryKegiatan({DetailKegiatan detailKegiatan})
      : super(detailKegiatan: detailKegiatan);
}

class SuccessHistoryKegiatan extends PilihKegiatanState {
  final List<DetailKegiatan> list;

  SuccessHistoryKegiatan(this.list, {DetailKegiatan detailKegiatan})
      : super(detailKegiatan: detailKegiatan);
}

class ErrorHistoryKegiatan extends PilihKegiatanState {
  final String message;

  ErrorHistoryKegiatan(this.message, {DetailKegiatan detailKegiatan})
      : super(detailKegiatan: detailKegiatan);
}
