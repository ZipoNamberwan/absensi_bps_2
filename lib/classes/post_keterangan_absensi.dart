class PostKeteranganAbsensi {
  String nip;
  String keterangan;
  String idstatus;
  String datetime;
  String base64Image;
  String fileName;
  String bukti;

  PostKeteranganAbsensi(
      {this.nip,
      this.keterangan,
      this.idstatus,
      this.datetime,
      this.base64Image,
      this.fileName,
      this.bukti});

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["nip"] = nip;
    map["keterangan"] = keterangan;
    map["status"] = idstatus;
    map["tanggal"] = datetime;

    return map;
  }

  factory PostKeteranganAbsensi.fromJson(Map<String, dynamic> json) {
    return PostKeteranganAbsensi(
      nip: json['nip'],
      keterangan: json['keterangan'],
      idstatus: json['status'],
      datetime: json['tanggal'],
      bukti: json['bukti'],
    );
  }
}
