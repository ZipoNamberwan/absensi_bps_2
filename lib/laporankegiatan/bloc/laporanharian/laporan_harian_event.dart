import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LaporanHarianEvent extends Equatable {
  const LaporanHarianEvent();
}

class UpdateTanggalLaporanHarian extends LaporanHarianEvent {
  final DateTime tanggal;

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

class UpdateKegiatanHarian extends LaporanHarianEvent {
  final Kegiatan kegiatan;

  UpdateKegiatanHarian(this.kegiatan);

  @override
  List<Object> get props => [kegiatan];
}

class StartHapusKegiatanHarian extends LaporanHarianEvent {
  final int index;
  final String id;

  StartHapusKegiatanHarian(this.index, this.id);

  @override
  List<Object> get props => [index, id];
}

class FinalHapusKegiatanHarian extends LaporanHarianEvent {
  final int index;
  final String id;

  FinalHapusKegiatanHarian(this.index, this.id);

  @override
  List<Object> get props => [index, id];
}

class GetKegiatanList extends LaporanHarianEvent {
  final String nip;
  final String tanggal;

  GetKegiatanList(this.nip, this.tanggal);

  @override
  List<Object> get props => [nip, tanggal];
}
