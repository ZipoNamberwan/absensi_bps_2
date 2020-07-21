import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PilihKegiatanEvent extends Equatable {
  const PilihKegiatanEvent();
}

class GetHistoryKegiatan extends PilihKegiatanEvent {
  final String nip;
  final String searchText;

  GetHistoryKegiatan(this.nip, this.searchText);

  @override
  List<Object> get props => [nip];
}

class UpdateNamaKegiatan extends PilihKegiatanEvent {
  final String nip;
  final String nama;

  UpdateNamaKegiatan(this.nip, this.nama);

  @override
  List<Object> get props => [nip, nama];
}

class UpdateSatuanKegiatan extends PilihKegiatanEvent {
  final String satuan;

  UpdateSatuanKegiatan(this.satuan);

  @override
  List<Object> get props => [satuan];
}
