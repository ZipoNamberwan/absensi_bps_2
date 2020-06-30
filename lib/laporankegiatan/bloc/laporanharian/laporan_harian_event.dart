import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LaporanHarianEvent extends Equatable {
  const LaporanHarianEvent();
}

class UpdateTanggalLaporanHarian extends LaporanHarianEvent {
  final String tanggal;

  UpdateTanggalLaporanHarian(this.tanggal);

  @override
  List<Object> get props => [tanggal];
}

class TambahKegiatanHarian extends LaporanHarianEvent {
  final Kegiatan kegiatan;

  TambahKegiatanHarian(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}

class HapusKegiatanHarian extends LaporanHarianEvent {
  final Kegiatan kegiatan;

  HapusKegiatanHarian(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}
