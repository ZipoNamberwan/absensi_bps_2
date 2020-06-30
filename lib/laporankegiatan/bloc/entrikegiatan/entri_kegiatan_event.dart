import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EntriKegiatanEvent extends Equatable {
  const EntriKegiatanEvent();
}

class UpdateDetailKegiatan extends EntriKegiatanEvent {
  final DetailKegiatan detailKegiatan;

  UpdateDetailKegiatan(this.detailKegiatan);

  @override
  List<Object> get props => [detailKegiatan];
}

class UpdateVolumeKegiatan extends EntriKegiatanEvent {
  final double volume;

  UpdateVolumeKegiatan(this.volume);

  @override
  List<Object> get props => [volume];
}

class UpdateDurasiKegiatan extends EntriKegiatanEvent {
  final double durasi;

  UpdateDurasiKegiatan(this.durasi);

  @override
  List<Object> get props => [durasi];
}

class UpdateSatuanDurasiKegiatan extends EntriKegiatanEvent {
  final String satuanDurasi;

  UpdateSatuanDurasiKegiatan(this.satuanDurasi);

  @override
  List<Object> get props => [satuanDurasi];
}

class UpdatePemberiTugasKegiatan extends EntriKegiatanEvent {
  final String pemberiTugas;

  UpdatePemberiTugasKegiatan(this.pemberiTugas);

  @override
  List<Object> get props => [pemberiTugas];
}
