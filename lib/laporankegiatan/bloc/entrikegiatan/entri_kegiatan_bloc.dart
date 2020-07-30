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
    } else if (event is UpdateKeterangan) {
      yield* mapUpdateKeteranganToState(event.keterangan);
    } else if (event is UpdateTanggal) {
      yield* mapUpdateTanggalToState(event.tanggal);
    } else if (event is PostKegiatan) {
      yield* mapPostKegiatanToState(event.nip);
    } else if (event is InitPage) {
      yield* mapInitPageToState(event.kegiatan, event.selectedDateTime);
    } else if (event is PostEditKegiatan) {
      yield* mapPostEditKegiatanToState(event.nip);
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

  Stream<EntriKegiatanState> mapUpdateKeteranganToState(
      String keterangan) async* {
    yield EntriKegiatanState(
        kegiatan: state.kegiatan.copyWith(keterangan: keterangan),
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
            kegiatan: state.kegiatan.copyWith(id: result.data['id'].toString()),
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

  Stream<EntriKegiatanState> mapPostEditKegiatanToState(String nip) async* {
    yield LoadingPost(
        kegiatan: state.kegiatan,
        listSatuanDurasi: state.listSatuanDurasi,
        listStatusKegiatan: state.listStatusKegiatan);

    try {
      Post result = await repository.updateKegiatan(nip, state.kegiatan);
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

  Stream<EntriKegiatanState> mapInitPageToState(
      Kegiatan kegiatan, DateTime selectedDateTime) async* {
    yield InitialEntriKegiatanState();

    try {
      var status = await repository.getStatusKegiatan();
      var satuan = await repository.getSatuanDurasi();

      if (status is List && satuan is List) {
        yield EntriKegiatanState(
            listStatusKegiatan: status,
            listSatuanDurasi: satuan,
            kegiatan: kegiatan == null
                ? state.kegiatan.copyWith(tanggal: selectedDateTime)
                : kegiatan.copyWith(
                    tanggal: selectedDateTime,
                    statusKegiatan: _getSelectedStatusKegiatan(
                        status, kegiatan.statusKegiatan),
                    satuanDurasi: _getSelectedSatuanDurasi(
                        satuan, kegiatan.satuanDurasi)));
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

  SatuanDurasi _getSelectedSatuanDurasi(
      List<SatuanDurasi> list, SatuanDurasi satuanDurasi) {
    if (satuanDurasi != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == satuanDurasi.id) {
          return list[i];
        }
      }
    }
    return null;
  }

  StatusKegiatan _getSelectedStatusKegiatan(
      List<StatusKegiatan> list, StatusKegiatan statusKegiatan) {
    if (statusKegiatan != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == statusKegiatan.id) {
          return list[i];
        }
      }
    }
    return null;
  }
}
