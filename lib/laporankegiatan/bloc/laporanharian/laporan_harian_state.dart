import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';

class LaporanHarianState {
  final List<Kegiatan> listKegiatan;

  LaporanHarianState({this.listKegiatan});
}

class InitialLaporanHarianState extends LaporanHarianState {
  InitialLaporanHarianState() : super(listKegiatan: []);
}

class LoadingListKegiatan extends LaporanHarianState {
  LoadingListKegiatan({List<Kegiatan> listKegiatan})
      : super(listKegiatan: listKegiatan);
}

class ErrorListKegiatan extends LaporanHarianState {
  final String message;

  ErrorListKegiatan(this.message, {List<Kegiatan> listKegiatan})
      : super(listKegiatan: listKegiatan);
}

class LoadingHapusKegiatan extends LaporanHarianState {
  final int index;

  LoadingHapusKegiatan(this.index, {List<Kegiatan> listKegiatan})
      : super(listKegiatan: listKegiatan);
}

class SuccessHapusKegiatan extends LaporanHarianState {
  final int index;

  SuccessHapusKegiatan(this.index, {List<Kegiatan> listKegiatan})
      : super(listKegiatan: listKegiatan);
}

class ErrorHapusKegiatan extends LaporanHarianState {
  final int index;
  final String message;

  ErrorHapusKegiatan(this.message, this.index, {List<Kegiatan> listKegiatan})
      : super(listKegiatan: listKegiatan);
}
