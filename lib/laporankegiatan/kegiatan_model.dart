class Kegiatan {
  final String id;
  final DetailKegiatan detailKegiatan;
  final double volume;
  final double durasi;
  final String satuanDurasi;
  final String pemberiTugas;
  final String keterangan;

  Kegiatan({
    this.id,
    this.detailKegiatan,
    this.volume,
    this.durasi,
    this.satuanDurasi,
    this.pemberiTugas,
    this.keterangan,
  });

  bool isValid() {
    return detailKegiatan.isValid() && volume != null && volume != 0;
  }

  Kegiatan copyWith(
      {String id,
      DetailKegiatan detailKegiatan,
      double volume,
      double durasi,
      String satuanDurasi,
      String pemberiTugas,
      String keterangan}) {
    return Kegiatan(
      id: id ?? this.id,
      durasi: durasi ?? this.durasi,
      detailKegiatan: detailKegiatan ?? this.detailKegiatan,
      keterangan: keterangan ?? this.keterangan,
      pemberiTugas: pemberiTugas ?? this.pemberiTugas,
      satuanDurasi: satuanDurasi ?? this.satuanDurasi,
      volume: volume ?? this.volume,
    );
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

  static List<DetailKegiatan> getExampleKegiatan() {
    List<DetailKegiatan> list = List();
    list.add(
        DetailKegiatan(nama: "Melakukan backup data Susenas", satuan: "File"));
    list.add(DetailKegiatan(nama: "Membuat publikasi Susenas", satuan: "buku"));
    list.add(DetailKegiatan(
        nama: "Melakukan perbaikan jaringan internet di Bidang Nerwilis",
        satuan: "Kegiatan"));
    list.add(DetailKegiatan(
        nama: "Melakukan perbaikan jaringan internet di Bidang Nerwilis",
        satuan: "Kegiatan"));

    list.add(
        DetailKegiatan(nama: "Menandatangi nota bensin", satuan: "Kegiatan"));

    list.add(DetailKegiatan(
        nama: "Membuat proyek bisnis SAAS LMS guruku.id", satuan: "Kegiatan"));

    list.add(DetailKegiatan(
        nama: "Melanjutkan proyek bisnis flyereats.in", satuan: "Kegiatan"));

    return list;
  }
}
