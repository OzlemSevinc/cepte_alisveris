import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cepte_alisveris/data/entity/urunler.dart';
import 'package:cepte_alisveris/data/repo/urunlerdao_repository.dart';

class UrunlerCubit extends Cubit<List<Urunler>> {
  UrunlerCubit() : super(<Urunler>[]);

  final urunlerRepo = UrunlerDaoRepository();
  List<Urunler> tumUrunler = [];
  String? seciliSiralama;
  String seciliFiltre = "Tümü";

  Future<void> tumUrunleriYukle() async {
    try {
      tumUrunler = await urunlerRepo.tumUrunleriGetir();
      siralaVeFiltrele();
    } catch (e) {
      emit(<Urunler>[]);
      print("Ürünler yüklenemedi: $e");
    }
  }

  Future<void> ara(String aramaKelimesi) async {
    try {
      final aramaSonucu = tumUrunler
          .where((urun) =>
          urun.ad.toLowerCase().contains(aramaKelimesi.toLowerCase()))
          .toList();
      emit(aramaSonucu);
    } catch (e) {
      print("Ürünler aranamadı: $e");
    }
  }

  void sirala(String? siralama) {
    seciliSiralama = siralama;
    siralaVeFiltrele();
  }

  void filtrele(String filtre) {
    seciliFiltre = filtre;
    siralaVeFiltrele();
  }

  void siralaVeFiltrele() {

    var siraliVeFiltreliListe = List<Urunler>.from(tumUrunler);

    if (seciliFiltre != "Tümü") {
      siraliVeFiltreliListe =
          siraliVeFiltreliListe.where((urun) => urun.kategori == seciliFiltre).toList();
    }

    if (seciliSiralama != null) {
      switch (seciliSiralama) {
        case "A-Z":
          siraliVeFiltreliListe.sort((a, b) => a.ad.compareTo(b.ad));
          break;
        case "Z-A":
          siraliVeFiltreliListe.sort((a, b) => b.ad.compareTo(a.ad));
          break;
        case "Artan Fiyat":
          siraliVeFiltreliListe.sort((a, b) => a.fiyat.compareTo(b.fiyat));
          break;
        case "Azalan Fiyat":
          siraliVeFiltreliListe.sort((a, b) => b.fiyat.compareTo(a.fiyat));
          break;
      }
    }

    emit(siraliVeFiltreliListe);
  }
}
