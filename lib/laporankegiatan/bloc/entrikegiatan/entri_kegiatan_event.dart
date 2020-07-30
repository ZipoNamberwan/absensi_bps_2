import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EntriKegiatanEvent extends Equatable {
  const EntriKegiatanEvent();
}

class InitPage extends EntriKegiatanEvent {
  final Kegiatan kegiatan;
  final DateTime selectedDateTime;

  InitPage(this.kegiatan, this.selectedDateTime);

  @override
  List<Object> get props => [kegiatan];
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
  final SatuanDurasi satuanDurasi;

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

class UpdateStatusKegiatan extends EntriKegiatanEvent {
  final StatusKegiatan statusKegiatan;

  UpdateStatusKegiatan(this.statusKegiatan);

  @override
  List<Object> get props => [statusKegiatan];
}

class UpdateTanggal extends EntriKegiatanEvent {
  final DateTime tanggal;

  UpdateTanggal(this.tanggal);

  @override
  List<Object> get props => [tanggal];
}

class UpdateKeterangan extends EntriKegiatanEvent {
  final String keterangan;

  UpdateKeterangan(this.keterangan);

  @override
  List<Object> get props => [keterangan];
}

class PostKegiatan extends EntriKegiatanEvent {
  final String nip;

  PostKegiatan(this.nip);

  @override
  List<Object> get props => [];
}

class PostEditKegiatan extends EntriKegiatanEvent {
  final String nip;

  PostEditKegiatan(this.nip);

  @override
  List<Object> get props => [];
}
