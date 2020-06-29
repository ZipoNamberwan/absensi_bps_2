import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PilihKegiatanEvent extends Equatable {
  const PilihKegiatanEvent();
}

class GetHistoryKegiatan extends PilihKegiatanEvent {
  final String nip;

  GetHistoryKegiatan(this.nip);

  @override
  List<Object> get props => [nip];
}

class UpdateNamaKegiatan extends PilihKegiatanEvent {
  final String nama;

  UpdateNamaKegiatan(this.nama);

  @override
  List<Object> get props => [nama];
}

class UpdateSatuanKegiatan extends PilihKegiatanEvent {
  final String satuan;

  UpdateSatuanKegiatan(this.satuan);

  @override
  List<Object> get props => [satuan];
}
