import 'sepet_urunler.dart';

class SepetUrunlerCevap {
  List<SepetUrunler> urunlerSepeti;
  int success;

  SepetUrunlerCevap({required this.urunlerSepeti, required this.success});

  factory SepetUrunlerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["urunler_sepeti"] as List;
    int success = json["success"] as int;
    var urunlerSepeti =
    jsonArray.map((jsonSepetUrun) => SepetUrunler.fromJson(jsonSepetUrun)).toList();
    return SepetUrunlerCevap(urunlerSepeti: urunlerSepeti, success: success);
  }
}
