import 'dart:async';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PilihKegiatanBloc extends Bloc<PilihKegiatanEvent, PilihKegiatanState> {
  DataRepository repository = DataRepository();

  @override
  PilihKegiatanState get initialState => InitialPilihKegiatanState();

  @override
  Stream<PilihKegiatanState> mapEventToState(
    PilihKegiatanEvent event,
  ) async* {
    if (event is UpdateNamaKegiatan) {
      yield* mapUpdateNamaKegiatanToState(event.nip, event.nama);
    } else if (event is UpdateSatuanKegiatan) {
      yield* mapUpdateSatuanKegiatanToState(event.satuan);
    } else if (event is GetHistoryKegiatan) {
      yield* mapGetHistoryKegiatanToState(event.nip, event.searchText);
    }
  }

  Stream<PilihKegiatanState> mapUpdateNamaKegiatanToState(
      String nip, String nama) async* {
    yield PilihKegiatanState(
        detailKegiatan: state.detailKegiatan.copyWith(nama: nama),
        listHistoryKegiatan: state.listHistoryKegiatan);
    add(GetHistoryKegiatan(nip, nama));
  }

  Stream<PilihKegiatanState> mapUpdateSatuanKegiatanToState(
      String satuan) async* {
    yield PilihKegiatanState(
        detailKegiatan: state.detailKegiatan.copyWith(satuan: satuan),
        listHistoryKegiatan: state.listHistoryKegiatan);
  }

  Stream<PilihKegiatanState> mapGetHistoryKegiatanToState(
      String nip, String searchText) async* {
    yield LoadingHistoryKegiatan(
        listHistoryKegiatan: state.listHistoryKegiatan,
        detailKegiatan: state.detailKegiatan);
    try {
      List<DetailKegiatan> result =
          await repository.getHistoryKegiatan(nip, searchText);
      if (result is List) {
        yield PilihKegiatanState(
            listHistoryKegiatan: result, detailKegiatan: state.detailKegiatan);
      } else {
        yield ErrorHistoryKegiatan((result as String),
            detailKegiatan: state.detailKegiatan,
            listHistoryKegiatan: state.listHistoryKegiatan);
      }
    } catch (e) {
      yield ErrorHistoryKegiatan(e.toString(),
          detailKegiatan: state.detailKegiatan,
          listHistoryKegiatan: state.listHistoryKegiatan);
    }
  }
}
