import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cepte_alisveris/ui/cubit/sepet_cubit.dart';
import 'package:cepte_alisveris/data/entity/sepet_urunler.dart';
import 'anasayfa.dart';

class SepetSayfa extends StatefulWidget {
  final String kullaniciAdi;

  const SepetSayfa({super.key, required this.kullaniciAdi});

  @override
  _SepetSayfaState createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  late SepetCubit sepetCubit;
  List<SepetUrunler> siraliSepet = [];

  @override
  void initState() {
    super.initState();
    sepetCubit = SepetCubit();
    sepetCubit.sepettekiUrunleriYukle(widget.kullaniciAdi);
  }

  void alfabetikSepet(List<SepetUrunler> sepet) {
    siraliSepet = List<SepetUrunler>.from(sepet)
      ..sort((a, b) => a.ad.compareTo(b.ad));
  }

  Future<void> siparisTamamla() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sipariş Tamamlandı"),
          content: const Text("Siparişiniz başarıyla tamamlandı."),
          actions: [
            TextButton(
              onPressed: () {
                sepetCubit.sepetiTemizle(widget.kullaniciAdi);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Anasayfa()),
                      (route) => false,
                );
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepetim",style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF116980),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF116980),
                  Colors.white,
                ]
            )
        ),
        child: BlocProvider(
          create: (context) => sepetCubit,
          child: BlocBuilder<SepetCubit, List<SepetUrunler>>(
            builder: (context, sepet) {
              alfabetikSepet(sepet);
              double toplamFiyat = 0.0;
              for (var item in siraliSepet) {
                toplamFiyat += item.fiyat * item.siparisAdeti;
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: siraliSepet.length,
                      itemBuilder: (context, index) {
                        final item = siraliSepet[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  "http://kasimadalan.pe.hu/urunler/resimler/${item.resim}",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.ad,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Fiyat: ${item.fiyat} ₺",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Toplam: ${item.fiyat * item.siparisAdeti} ₺",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        item.siparisAdeti > 1
                                            ? Icons.remove
                                            : Icons.delete,
                                        color: item.siparisAdeti > 1
                                            ? Colors.black
                                            : Colors.red,
                                      ),
                                      onPressed: () {
                                        if (item.siparisAdeti > 1) {
                                          sepetCubit.sepettenUrunSil(
                                            sepetId: item.sepetId,
                                            kullaniciAdi: widget.kullaniciAdi,
                                          );
                                          sepetCubit.sepeteUrunEkle(
                                            ad: item.ad,
                                            resim: item.resim,
                                            kategori: item.kategori,
                                            fiyat: item.fiyat,
                                            marka: item.marka,
                                            siparisAdeti: item.siparisAdeti - 1,
                                            kullaniciAdi: widget.kullaniciAdi,
                                          );
                                        } else {
                                          sepetCubit.sepettenUrunSil(
                                            sepetId: item.sepetId,
                                            kullaniciAdi: widget.kullaniciAdi,
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Ürün sepetten silindi"))
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      "${item.siparisAdeti}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        sepetCubit.sepettenUrunSil(
                                          sepetId: item.sepetId,
                                          kullaniciAdi: widget.kullaniciAdi,
                                        );
                                        sepetCubit.sepeteUrunEkle(
                                          ad: item.ad,
                                          resim: item.resim,
                                          kategori: item.kategori,
                                          fiyat: item.fiyat,
                                          marka: item.marka,
                                          siparisAdeti: item.siparisAdeti + 1,
                                          kullaniciAdi: widget.kullaniciAdi,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Color(0x02116980),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sepet Tutarı: ${toplamFiyat.toStringAsFixed(2)} ₺",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            siparisTamamla();
                          },
                          child: const Text("Siparişi Tamamla"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFF116980),
                            foregroundColor:Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
