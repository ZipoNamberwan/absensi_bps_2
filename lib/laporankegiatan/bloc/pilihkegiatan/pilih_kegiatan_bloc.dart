import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PilihKegiatanBloc extends Bloc<PilihKegiatanEvent, PilihKegiatanState> {
  @override
  PilihKegiatanState get initialState => InitialPilihKegiatanState();

  @override
  Stream<PilihKegiatanState> mapEventToState(
    PilihKegiatanEvent event,
  ) async* {
    if (event is UpdateNamaKegiatan) {
      yield* mapUpdateNamaKegiatanToState(event.nama);
    } else if (event is UpdateSatuanKegiatan) {
      yield* mapUpdateSatuanKegiatanToState(event.satuan);
    }
  }

  Stream<PilihKegiatanState> mapUpdateNamaKegiatanToState(String nama) async* {
    yield PilihKegiatanState(
        detailKegiatan: state.detailKegiatan.copyWith(nama: nama));
  }

  Stream<PilihKegiatanState> mapUpdateSatuanKegiatanToState(
      String satuan) async* {
    yield PilihKegiatanState(
        detailKegiatan: state.detailKegiatan.copyWith(satuan: satuan));
  }
}
