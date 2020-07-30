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
        id: parsedJson['id'].toString(),
        detailKegiatan: DetailKegiatan(
            nama: parsedJson['namakegiatan'],
            satuan: parsedJson['satuankegiatan']),
        statusKegiatan: parsedJson['datastatuskegiatan'] != null
            ? StatusKegiatan.fromJson(parsedJson['datastatuskegiatan'])
            : null,
        satuanDurasi: parsedJson['datasatuandurasi'] != null
            ? SatuanDurasi.fromJson(parsedJson['datasatuandurasi'])
            : null,
        keterangan: parsedJson['keterangan'],
        durasi: parsedJson['durasi'] != null
            ? double.parse(parsedJson['durasi'].toString())
            : null,
        volume: parsedJson['volume'] != null
            ? double.parse(parsedJson['volume'].toString())
            : null,
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

  factory SatuanDurasi.fromJson(Map<String, dynamic> parsedJson) {
    return SatuanDurasi(
        id: parsedJson['id'].toString(), nama: parsedJson['satuan']);
  }
}

class StatusKegiatan {
  final String id;
  final String status;
  final String color;

  StatusKegiatan({this.id, this.status, this.color});

  factory StatusKegiatan.fromJson(Map<String, dynamic> parsedJson) {
    return StatusKegiatan(
        id: parsedJson['id'].toString(),
        status: parsedJson['statuskegiatan'],
        color: parsedJson['warna']);
  }
}
