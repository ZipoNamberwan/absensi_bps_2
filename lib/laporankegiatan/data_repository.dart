import 'package:absensi_bps_2/classes/keterangan_absensi.dart';
import 'package:absensi_bps_2/laporankegiatan/data_provider.dart';
import 'package:absensi_bps_2/laporankegiatan/kegiatan_model.dart';
import 'package:absensi_bps_2/laporankegiatan/post.dart';

class DataRepository {
  DataProvider provider = DataProvider();

  Future<dynamic> getKegiatan(String nip, String tanggal) async {
    Post response = await provider.getKegiatan(nip, tanggal);
    if (response.isSuccess) {
      var listKegiatanJson = response.data as List;
      List<Kegiatan> list = listKegiatanJson.map((e) {
        return Kegiatan.fromJson(e);
      }).toList();
      return list;
    } else {
      return response.message;
    }
  }

  Future<dynamic> getHistoryKegiatan(String nip, String searchText) async {
    Post response = await provider.getHistoryKegiatan(nip, searchText);
    if (response.isSuccess) {
      var listJson = response.data as List;
      List<DetailKegiatan> list = listJson.map((e) {
        return DetailKegiatan.fromJson(e);
      }).toList();
      return list;
    } else {
      return response.message;
    }
  }

  Future<Post> tambahKegiatan(String nip, Kegiatan kegiatan) async {
    Post response = await provider.tambahKegiatan(nip, kegiatan);
    return response;
  }

  Future<dynamic> getSatuanDurasi() async {
    Post response = await provider.getSatuanDurasi();
    if (response.isSuccess) {
      var listJson = response.data as List;
      List<SatuanDurasi> list = listJson.map((e) {
        return SatuanDurasi.fromJson(e);
      }).toList();
      return list;
    } else {
      return response.message;
    }
  }

  Future<dynamic> getStatusKegiatan() async {
    Post response = await provider.getStatus();
    if (response.isSuccess) {
      var listJson = response.data as List;
      List<StatusKegiatan> list = listJson.map((e) {
        return StatusKegiatan.fromJson(e);
      }).toList();
      return list;
    } else {
      return response.message;
    }
  }
}
