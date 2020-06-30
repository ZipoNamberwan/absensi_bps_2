import 'dart:async';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EntriKegiatanBloc extends Bloc<EntriKegiatanEvent, EntriKegiatanState> {
  @override
  EntriKegiatanState get initialState => InitialEntriKegiatanState();

  @override
  Stream<EntriKegiatanState> mapEventToState(
    EntriKegiatanEvent event,
  ) async* {
    if (event is UpdateDetailKegiatan) {
      yield* mapUpdateDetailKegiatanToState(event.detailKegiatan);
    } else if (event is UpdateVolumeKegiatan) {
      yield* mapUpdateVolumeKegiatanToState(event.volume);
    } else if (event is UpdateDurasiKegiatan) {
      yield* mapUpdateDurasiKegiatanToState(event.durasi);
    } else if (event is UpdateSatuanDurasiKegiatan) {
      yield* mapUpdateSatuanDurasiKegiatanToState(event.satuanDurasi);
    } else if (event is UpdatePemberiTugasKegiatan) {
      yield* mapUpdatePemberiTugasKegiatanToState(event.pemberiTugas);
    }
  }

  Stream<EntriKegiatanState> mapUpdateDetailKegiatanToState(
      DetailKegiatan detailKegiatan) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(detailKegiatan: detailKegiatan));
  }

  Stream<EntriKegiatanState> mapUpdateVolumeKegiatanToState(
      double volume) async* {
    yield EntriKegiatanState(kegiatan: state.kegiatan.copyWith(volume: volume));
  }

  Stream<EntriKegiatanState> mapUpdateDurasiKegiatanToState(
      double durasi) async* {
    yield EntriKegiatanState(kegiatan: state.kegiatan.copyWith(durasi: durasi));
  }

  Stream<EntriKegiatanState> mapUpdateSatuanDurasiKegiatanToState(
      String satuanDurasi) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(satuanDurasi: satuanDurasi));
  }

  Stream<EntriKegiatanState> mapUpdatePemberiTugasKegiatanToState(
      String pemberiTugas) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(pemberiTugas: pemberiTugas));
  }
}
