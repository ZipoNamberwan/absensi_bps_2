import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class PilihKegiatanState {
  final DetailKegiatan detailKegiatan;
  final List<DetailKegiatan> listHistoryKegiatan;

  PilihKegiatanState({this.detailKegiatan, this.listHistoryKegiatan});
}

class InitialPilihKegiatanState extends PilihKegiatanState {
  InitialPilihKegiatanState()
      : super(detailKegiatan: DetailKegiatan(), listHistoryKegiatan: []);
}

class LoadingHistoryKegiatan extends PilihKegiatanState {
  LoadingHistoryKegiatan(
      {DetailKegiatan detailKegiatan, List<DetailKegiatan> listHistoryKegiatan})
      : super(
            detailKegiatan: detailKegiatan,
            listHistoryKegiatan: listHistoryKegiatan);
}

class ErrorHistoryKegiatan extends PilihKegiatanState {
  final String message;

  ErrorHistoryKegiatan(this.message,
      {DetailKegiatan detailKegiatan, List<DetailKegiatan> listHistoryKegiatan})
      : super(
            detailKegiatan: detailKegiatan,
            listHistoryKegiatan: listHistoryKegiatan);
}
