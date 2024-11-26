class SepetUrunler {
  int sepetId;
  String ad;
  String resim;
  String kategori;
  int fiyat;
  String marka;
  int siparisAdeti;
  String kullaniciAdi;

  SepetUrunler({
    required this.sepetId,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
    required this.siparisAdeti,
    required this.kullaniciAdi,
  });

  factory SepetUrunler.fromJson(Map<String, dynamic> json) {
    return SepetUrunler(
      sepetId: json["sepetId"] as int,
      ad: json["ad"] as String,
      resim: json["resim"] as String,
      kategori: json["kategori"] as String,
      fiyat: json["fiyat"] as int,
      marka: json["marka"] as String,
      siparisAdeti: json["siparisAdeti"] as int,
      kullaniciAdi: json["kullaniciAdi"] as String,
    );
  }
}
