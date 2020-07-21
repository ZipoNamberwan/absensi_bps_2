import 'dart:async';
import 'package:absensi_bps_2/laporankegiatan/data_repository.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/post.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EntriKegiatanBloc extends Bloc<EntriKegiatanEvent, EntriKegiatanState> {
  DataRepository repository = DataRepository();

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
    } else if (event is UpdateStatusKegiatan) {
      yield* mapUpdateStatusKegiatanToState(event.statusKegiatan);
    } else if (event is UpdateTanggal) {
      yield* mapUpdateTanggalToState(event.tanggal);
    } else if (event is PostKegiatan) {
      yield* mapPostKegiatanToState(event.nip);
    } else if (event is InitPage) {
      yield* mapInitPageToState();
    }
  }

  Stream<EntriKegiatanState> mapUpdateDetailKegiatanToState(
      DetailKegiatan detailKegiatan) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(detailKegiatan: detailKegiatan),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdateVolumeKegiatanToState(
      double volume) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(volume: volume),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdateDurasiKegiatanToState(
      double durasi) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(durasi: durasi),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdateSatuanDurasiKegiatanToState(
      SatuanDurasi satuanDurasi) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(satuanDurasi: satuanDurasi),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdatePemberiTugasKegiatanToState(
      String pemberiTugas) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(pemberiTugas: pemberiTugas),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdateStatusKegiatanToState(
      StatusKegiatan statusKegiatan) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(statusKegiatan: statusKegiatan),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapUpdateTanggalToState(DateTime tanggal) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(tanggal: tanggal),
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);
  }

  Stream<EntriKegiatanState> mapPostKegiatanToState(String nip) async* {
    yield LoadingPost(
        kegiatan: state.kegiatan,
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);

    try {
      Post result = await repository.tambahKegiatan(nip, state.kegiatan);
      if (result.isSuccess) {
        yield SuccessPost(
            kegiatan: state.kegiatan,
            listSatuanDurasi: state.listSatuanDurasi,
            listStatusKegiatan: state.listStatusKegiatan);
      } else {
        yield ErrorPost(result.message,
            kegiatan: state.kegiatan,
            listSatuanDurasi: state.listSatuanDurasi,
            listStatusKegiatan: state.listStatusKegiatan);
      }
    } catch (e) {
      yield ErrorPost(e.toString(),
          kegiatan: state.kegiatan,
          listSatuanDurasi: state.listSatuanDurasi,
          listStatusKegiatan: state.listStatusKegiatan);
    }
  }

  Stream<EntriKegiatanState> mapInitPageToState() async* {
    yield InitialEntriKegiatanState();

    try {
      var status = await repository.getStatusKegiatan();
      var satuan = await repository.getSatuanDurasi();

      if (status is List && satuan is List) {
        yield EntriKegiatanState(
            listStatusKegiatan: status,
            listSatuanDurasi: satuan,
            kegiatan: state.kegiatan);
      } else {
        yield ErrorInitEntriKegiatanState(
            (status as String) + (satuan as String),
            kegiatan: state.kegiatan,
            listSatuanDurasi: state.listSatuanDurasi,
            listStatusKegiatan: state.listStatusKegiatan);
      }
    } catch (e) {
      yield ErrorInitEntriKegiatanState(e.toString(),
          kegiatan: state.kegiatan,
          listSatuanDurasi: state.listSatuanDurasi,
          listStatusKegiatan: state.listStatusKegiatan);
    }
  }
}
