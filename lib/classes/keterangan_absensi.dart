class KeteranganAbsensi {
  Pegawai pegawai;
  Status status;
  String keterangan;
  DateTime dateTime;
  String gambar;

  KeteranganAbsensi(
      {this.pegawai, this.status, this.keterangan, this.dateTime, this.gambar});

  factory KeteranganAbsensi.fromJson(Map<String, dynamic> parsedJson) {
    return KeteranganAbsensi(
        pegawai: new Pegawai(
            nip: parsedJson['nip'],
            nama: parsedJson['nama'],
            idBidang: parsedJson['idbidang'],
            namaBidang: parsedJson['namabidang']),
        status: new Status(
            id: parsedJson['idstatusabsensi'], status: parsedJson['status']),
        keterangan: parsedJson['keterangan'],
        dateTime: DateTime.parse(parsedJson['tanggal']),
        gambar: parsedJson['bukti']);
  }
}

class KeteranganAbsensiList {
  List<KeteranganAbsensi> list;

  KeteranganAbsensiList({this.list});

  factory KeteranganAbsensiList.fromJson(List<dynamic> parsedJson) {
    List<KeteranganAbsensi> list =
        parsedJson.map((i) => KeteranganAbsensi.fromJson(i)).toList();
    return new KeteranganAbsensiList(list: list);
  }
}

class Pegawai {
  String nip;
  String nama;
  String idBidang;
  String namaBidang;
  String foto;
  String nipBaru;
  String email;

  Pegawai(
      {this.nip,
      this.nama,
      this.idBidang,
      this.namaBidang,
      this.foto,
      this.nipBaru,
      this.email});

  factory Pegawai.fromJson(Map<String, dynamic> parsedJson) {
    return Pegawai(
        nip: parsedJson['nip'],
        nama: parsedJson['nama'],
        idBidang: parsedJson['idbidang'],
        namaBidang: parsedJson['namabidang'],
        foto: parsedJson['foto'],
        email: parsedJson['email'],
        nipBaru: parsedJson['nipbaru']) ;
  }
}

class PegawaiList {
  List<Pegawai> list;

  PegawaiList({this.list});

  factory PegawaiList.fromJson(List<dynamic> parsedJson) {
    List<Pegawai> list = parsedJson.map((i) => Pegawai.fromJson(i)).toList();
    return new PegawaiList(list: list);
  }
}

class Status {
  String id;
  String status;

  Status({this.id, this.status});

  factory Status.fromJson(Map<String, dynamic> parsedJson) {
    return Status(id: parsedJson['id'], status: parsedJson['status']);
  }
}

class StatusList {
  List<Status> list;

  StatusList({this.list});

  factory StatusList.fromJson(List<dynamic> parsedJson) {
    List<Status> list = parsedJson.map((i) => Status.fromJson(i)).toList();
    return new StatusList(list: list);
  }
}
