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
    } else if (event is HapusKegiatanHarian) {
      yield* mapHapusKegiatanHarianToState(event.index);
    }
  }

  Stream<LaporanHarianState> mapUpdateTanggalLaporanHarianToState(
      DateTime tanggal) async* {
    yield LaporanHarianState(
        laporanHarian: state.laporanHarian.copyWith(tanggal: tanggal));
  }

  Stream<LaporanHarianState> mapTambahKegiatanHarianToState(
      Kegiatan kegiatan) async* {
    List<Kegiatan> list = state.laporanHarian.listKegiatan;
    list.insert(0, kegiatan);
    yield LaporanHarianState(
        laporanHarian: state.laporanHarian.copyWith(listKegiatan: list));
  }

  Stream<LaporanHarianState> mapHapusKegiatanHarianToState(int index) async* {
    List<Kegiatan> list = state.laporanHarian.listKegiatan;
    list.removeAt(index);
    yield LaporanHarianState(
        laporanHarian: state.laporanHarian.copyWith(listKegiatan: list));
  }
}
