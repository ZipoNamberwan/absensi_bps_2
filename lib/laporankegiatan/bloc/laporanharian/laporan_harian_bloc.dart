import 'dart:async';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class LaporanHarianBloc extends Bloc<LaporanHarianEvent, LaporanHarianState> {
  @override
  LaporanHarianState get initialState => InitialLaporanHarianState();

  @override
  Stream<LaporanHarianState> mapEventToState(
    LaporanHarianEvent event,
  ) async* {
    if (event is UpdateTanggalLaporanHarian) {
      yield* mapUpdateTanggalLaporanHarianToState(event.tanggal);
    } else if (event is TambahKegiatanHarian) {
      yield* mapTambahKegiatanHarianToState(event.kegiatan);
    }
  }

  Stream<LaporanHarianState> mapUpdateTanggalLaporanHarianToState(
      String tanggal) async* {
    yield state.copyWith(tanggal: tanggal);
  }

  Stream<LaporanHarianState> mapTambahKegiatanHarianToState(
      Kegiatan kegiatan) async* {
    List<Kegiatan> list = state.listKegiatan;
    list.add(kegiatan);
    yield state.copyWith(listKegiatan: list);
  }
}
