import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/sepet_urunler.dart';

class SepetDaoRepository {
  final String baseUrl = "http://kasimadalan.pe.hu/urunler";

  Future<List<SepetUrunler>> sepettekiUrunleriGetir(String kullaniciAdi) async {
    final url = Uri.parse("$baseUrl/sepettekiUrunleriGetir.php");
    final cevap = await http.post(
      url,
      body: {"kullaniciAdi": kullaniciAdi},
    );

    if (cevap.statusCode == 200) {
      final jsonData = json.decode(cevap.body);
      final success = jsonData["success"] as int;

      if (success == 1) {
        final jsonArray = jsonData["urunler_sepeti"] as List;
        return jsonArray.map((e) => SepetUrunler.fromJson(e)).toList();
      } else {
        return <SepetUrunler>[];
      }
    } else {
      throw Exception("Sepet Yüklenemedi");
    }
  }


  Future<void> sepeteUrunEkle({
    required String ad,
    required String resim,
    required String kategori,
    required int fiyat,
    required String marka,
    required int siparisAdeti,
    required String kullaniciAdi,
  }) async {
    final url = Uri.parse("$baseUrl/sepeteUrunEkle.php");

    final urunVeri = {
      "ad": ad,
      "resim": resim,
      "kategori": kategori,
      "fiyat": fiyat.toString(),
      "marka": marka,
      "siparisAdeti": siparisAdeti.toString(),
      "kullaniciAdi": kullaniciAdi,
    };

    final cevap = await http.post(
      url,
      body: urunVeri,
    );

    if (cevap.statusCode != 200) {
      throw Exception("Ürün sepete eklenemedi");
    }
  }

  Future<void> sepettenUrunSil({
    required int sepetId,
    required String kullaniciAdi,
  }) async {
    final url = Uri.parse("$baseUrl/sepettenUrunSil.php");

    final silinecekVeri = {
      "sepetId": sepetId.toString(),
      "kullaniciAdi": kullaniciAdi,
    };

    final cevap = await http.post(
      url,
      body: silinecekVeri,
    );

    if (cevap.statusCode != 200) {
      throw Exception("Ürün sepetten silinemedi");
    }
  }
}
