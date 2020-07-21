class LaporanHarian {
  final DateTime tanggal;
  final List<Kegiatan> listKegiatan;

  LaporanHarian({this.tanggal, this.listKegiatan});

  bool isValid() {
    return tanggal != null && tanggal != "" && listKegiatan.isNotEmpty;
  }

  LaporanHarian copyWith({DateTime tanggal, List<Kegiatan> listKegiatan}) {
    return LaporanHarian(
        tanggal: tanggal ?? this.tanggal,
        listKegiatan: listKegiatan ?? this.listKegiatan);
  }
}

class Kegiatan {
  final String id;
  final DateTime tanggal;
  final DetailKegiatan detailKegiatan;
  final double volume;
  final double durasi;
  final SatuanDurasi satuanDurasi;
  final String pemberiTugas;
  final String keterangan;
  final StatusKegiatan statusKegiatan;

  Kegiatan({
    this.tanggal,
    this.statusKegiatan,
    this.id,
    this.detailKegiatan,
    this.volume,
    this.durasi,
    this.satuanDurasi,
    this.pemberiTugas,
    this.keterangan,
  });

  bool isValid() {
    return detailKegiatan.isValid() &&
        volume != null &&
        volume != 0 &&
        tanggal != null;
  }

  Kegiatan copyWith(
      {String id,
      DetailKegiatan detailKegiatan,
      double volume,
      double durasi,
      SatuanDurasi satuanDurasi,
      String pemberiTugas,
      String keterangan,
      DateTime tanggal,
      StatusKegiatan statusKegiatan}) {
    return Kegiatan(
        id: id ?? this.id,
        durasi: durasi ?? this.durasi,
        detailKegiatan: detailKegiatan ?? this.detailKegiatan,
        keterangan: keterangan ?? this.keterangan,
        pemberiTugas: pemberiTugas ?? this.pemberiTugas,
        satuanDurasi: satuanDurasi ?? this.satuanDurasi,
        volume: volume ?? this.volume,
        tanggal: tanggal ?? this.tanggal,
        statusKegiatan: statusKegiatan ?? this.statusKegiatan);
  }

  factory Kegiatan.fromJson(Map<String, dynamic> parsedJson) {
    return Kegiatan(
        id: parsedJson['id'],
        detailKegiatan: DetailKegiatan(
            nama: parsedJson['namakegiatan'],
            satuan: parsedJson['satuankegiatan']),
        statusKegiatan:
            StatusKegiatan.fromJson(parsedJson['datastatuskegiatan']),
        satuanDurasi: SatuanDurasi.fromJson(parsedJson['datasatuandurasi']),
        keterangan: parsedJson['keterangan'],
        durasi: parsedJson['durasi'],
        volume: parsedJson['volume'],
        pemberiTugas: parsedJson['pemberitugas'],
        tanggal: DateTime.parse(parsedJson['tanggal']));
  }
}

class DetailKegiatan {
  final String nama;
  final String satuan;

  DetailKegiatan({this.nama, this.satuan});

  bool isValid() {
    return nama != null && nama != "" && satuan != null && satuan != "";
  }

  DetailKegiatan copyWith({String nama, String satuan}) {
    return DetailKegiatan(
        nama: nama ?? this.nama, satuan: satuan ?? this.satuan);
  }

  factory DetailKegiatan.fromJson(Map<String, dynamic> parsedJson) {
    return DetailKegiatan(
        nama: parsedJson['namakegiatan'], satuan: parsedJson['satuankegiatan']);
  }
}

class SatuanDurasi {
  final String id;
  final String nama;

  SatuanDurasi({this.id, this.nama});

  static List<SatuanDurasi> getExampleSatuanDurasi() {
    List<SatuanDurasi> list = List();
    list.add(SatuanDurasi(id: "1", nama: "Jam"));
    list.add(SatuanDurasi(id: "2", nama: "Menit"));

    return list;
  }

  factory SatuanDurasi.fromJson(Map<String, dynamic> parsedJson) {
    return SatuanDurasi(
        id: parsedJson['id'].toString(), nama: parsedJson['satuan']);
  }
}

class StatusKegiatan {
  final String id;
  final String status;

  StatusKegiatan({this.id, this.status});

  factory StatusKegiatan.fromJson(Map<String, dynamic> parsedJson) {
    return StatusKegiatan(
        id: parsedJson['id'].toString(), status: parsedJson['statuskegiatan']);
  }
}
