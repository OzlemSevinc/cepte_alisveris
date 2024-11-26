import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cepte_alisveris/data/entity/sepet_urunler.dart';
import 'package:cepte_alisveris/data/repo/sepetdao_repository.dart';

class SepetCubit extends Cubit<List<SepetUrunler>> {
  SepetCubit() : super(<SepetUrunler>[]);

  final sepetRepo = SepetDaoRepository();

  Future<void> sepettekiUrunleriYukle(String kullaniciAdi) async {
    try {
      final liste = await sepetRepo.sepettekiUrunleriGetir(kullaniciAdi);
      emit(liste);
    } catch (e) {
      emit(<SepetUrunler>[]);
      print("Sepetteki ürünler yüklenemedi: $e");
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
    try {
      await sepetRepo.sepeteUrunEkle(
        ad: ad,
        resim: resim,
        kategori: kategori,
        fiyat: fiyat,
        marka: marka,
        siparisAdeti: siparisAdeti,
        kullaniciAdi: kullaniciAdi,
      );
      await sepettekiUrunleriYukle(kullaniciAdi);
    } catch (e) {
      print("Ürün sepete eklenemedi: $e");
    }
  }


  Future<void> sepettenUrunSil({
    required int sepetId,
    required String kullaniciAdi,
  }) async {
    try {
      await sepetRepo.sepettenUrunSil(sepetId: sepetId, kullaniciAdi: kullaniciAdi);
      await sepettekiUrunleriYukle(kullaniciAdi);
    } catch (e) {
      print("Ürün sepetten silinemedi: $e");
    }
  }

  Future<void> sepetiTemizle(String kullaniciAdi) async {
    try {
      List<SepetUrunler> sepet = await sepetRepo.sepettekiUrunleriGetir(kullaniciAdi);

      for (var item in sepet) {
        await sepetRepo.sepettenUrunSil(sepetId: item.sepetId, kullaniciAdi: kullaniciAdi);
      }
      emit([]);
    } catch (e) {
      print("Sepet temizlenemedi: $e");
    }
  }

}
