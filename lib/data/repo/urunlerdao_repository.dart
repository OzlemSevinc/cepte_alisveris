import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/urunler.dart';
import '../entity/urunler_cevap.dart';

class UrunlerDaoRepository {
  final String baseUrl = "http://kasimadalan.pe.hu/urunler";

  Future<List<Urunler>> tumUrunleriGetir() async {
    final url = Uri.parse("$baseUrl/tumUrunleriGetir.php");

    final cevap = await http.get(url);
    if (cevap.statusCode == 200) {
      return UrunlerCevap.fromJson(json.decode(cevap.body)).urunler;
    } else {
      throw Exception("Ürünler yüklenemedi");
    }
  }
}
