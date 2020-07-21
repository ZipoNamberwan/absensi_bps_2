import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class EntriKegiatanState {
  final Kegiatan kegiatan;
  final List<SatuanDurasi> listSatuanDurasi;
  final List<StatusKegiatan> listStatusKegiatan;

  EntriKegiatanState(
      {this.kegiatan, this.listSatuanDurasi, this.listStatusKegiatan});
}

class InitialEntriKegiatanState extends EntriKegiatanState {
  InitialEntriKegiatanState()
      : super(
            kegiatan: Kegiatan(detailKegiatan: DetailKegiatan()),
            listSatuanDurasi: [],
            listStatusKegiatan: []);
}

class ErrorInitEntriKegiatanState extends EntriKegiatanState {
  final String message;

  ErrorInitEntriKegiatanState(this.message,
      {Kegiatan kegiatan,
      List<SatuanDurasi> listSatuanDurasi,
      List<StatusKegiatan> listStatusKegiatan})
      : super(
            kegiatan: kegiatan,
            listSatuanDurasi: listSatuanDurasi,
            listStatusKegiatan: listStatusKegiatan);
}

class LoadingPost extends EntriKegiatanState {
  LoadingPost(
      {Kegiatan kegiatan,
      List<SatuanDurasi> listSatuanDurasi,
      List<StatusKegiatan> listStatusKegiatan})
      : super(
            kegiatan: kegiatan,
            listSatuanDurasi: listSatuanDurasi,
            listStatusKegiatan: listStatusKegiatan);
}

class SuccessPost extends EntriKegiatanState {
  SuccessPost(
      {Kegiatan kegiatan,
      List<SatuanDurasi> listSatuanDurasi,
      List<StatusKegiatan> listStatusKegiatan})
      : super(
            kegiatan: kegiatan,
            listSatuanDurasi: listSatuanDurasi,
            listStatusKegiatan: listStatusKegiatan);
}

class ErrorPost extends EntriKegiatanState {
  final String message;

  ErrorPost(this.message,
      {Kegiatan kegiatan,
      List<SatuanDurasi> listSatuanDurasi,
      List<StatusKegiatan> listStatusKegiatan})
      : super(
            kegiatan: kegiatan,
            listSatuanDurasi: listSatuanDurasi,
            listStatusKegiatan: listStatusKegiatan);
}
