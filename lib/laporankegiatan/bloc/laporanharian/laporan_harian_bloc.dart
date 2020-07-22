import 'dart:async';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/post.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class LaporanHarianBloc extends Bloc<LaporanHarianEvent, LaporanHarianState> {
  DataRepository repository = DataRepository();

  @override
  LaporanHarianState get initialState => InitialLaporanHarianState();

  @override
  Stream<LaporanHarianState> mapEventToState(
    LaporanHarianEvent event,
  ) async* {
    if (event is TambahKegiatanHarian) {
      yield* mapTambahKegiatanHarianToState(event.kegiatan);
    } else if (event is StartHapusKegiatanHarian) {
      yield* mapHapusKegiatanHarianToState(event.index, event.id);
    } else if (event is FinalHapusKegiatanHarian) {
      yield* mapFinalHapusKegiatanHarianToState(event.index, event.id);
    } else if (event is GetKegiatanList) {
      yield* mapGetKegiatanListToState(event.nip, event.tanggal);
    } else if (event is UpdateKegiatanHarian) {
      yield* mapUpdateKegiatanHarianToState(event.kegiatan);
    }
  }

  Stream<LaporanHarianState> mapTambahKegiatanHarianToState(
      Kegiatan kegiatan) async* {
    List<Kegiatan> list = state.listKegiatan;
    list.add(kegiatan);
    yield LaporanHarianState(listKegiatan: list);
  }

  Stream<LaporanHarianState> mapHapusKegiatanHarianToState(
      int index, String id) async* {
    yield LoadingHapusKegiatan(index, listKegiatan: state.listKegiatan);
    try {
      Post result = await repository.hapusKegiatan(id);
      if (result.isSuccess) {
        yield SuccessHapusKegiatan(index, listKegiatan: state.listKegiatan);
      } else {
        yield ErrorHapusKegiatan(result.message, index,
            listKegiatan: state.listKegiatan);
      }
    } catch (e) {
      yield ErrorHapusKegiatan(e.toString(), index,
          listKegiatan: state.listKegiatan);
    }
  }

  Stream<LaporanHarianState> mapGetKegiatanListToState(
      String nip, String tanggal) async* {
    yield LoadingListKegiatan(listKegiatan: state.listKegiatan);
    try {
      var result = await repository.getKegiatan(nip, tanggal);
      if (result is List) {
        yield LaporanHarianState(listKegiatan: result);
      } else {
        yield ErrorListKegiatan(result as String,
            listKegiatan: state.listKegiatan);
      }
    } catch (e) {
      yield ErrorListKegiatan(e.toString(), listKegiatan: state.listKegiatan);
    }
  }

  Stream<LaporanHarianState> mapFinalHapusKegiatanHarianToState(
      int index, String id) async* {
    List<Kegiatan> list = state.listKegiatan;
    list.removeAt(index);
    yield LaporanHarianState(listKegiatan: list);
  }

  Stream<LaporanHarianState> mapUpdateKegiatanHarianToState(
      Kegiatan kegiatan) async* {
    List<Kegiatan> list = state.listKegiatan;
    int index = list.indexWhere((element) => kegiatan.id == element.id);
    list[index] = kegiatan;

    yield LaporanHarianState(listKegiatan: list);
  }
}
