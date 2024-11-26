import 'urunler.dart';

class UrunlerCevap {
  List<Urunler> urunler;
  int success;

  UrunlerCevap({required this.urunler, required this.success});

  factory UrunlerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["urunler"] as List;
    int success = json["success"] as int;
    var urunler = jsonArray.map((jsonUrun) => Urunler.fromJson(jsonUrun)).toList();
    return UrunlerCevap(urunler: urunler, success: success);
  }
}
