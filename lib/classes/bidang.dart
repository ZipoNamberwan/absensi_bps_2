class Bidang {
  String id;
  String namabidang;
  String username;
  String password;

  Bidang({this.id, this.namabidang, this.username, this.password});

  factory Bidang.fromJson(Map<String, dynamic> parsedJson) {
    return Bidang(
        id: parsedJson['organisasi'],
        namabidang: parsedJson['namabidang'],
        username: parsedJson['username'],
        password: parsedJson['password']);
  }
}

class BidangList {
  List<Bidang> list;

  BidangList({this.list});

  factory BidangList.fromJson(List<dynamic> parsedJson) {
    List<Bidang> list = parsedJson.map((i) => Bidang.fromJson(i)).toList();
    return new BidangList(list: list);
  }
}