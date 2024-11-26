import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cepte_alisveris/data/entity/urunler.dart';
import 'package:cepte_alisveris/data/entity/sepet_urunler.dart';
import 'package:cepte_alisveris/ui/cubit/sepet_cubit.dart';

class DetaySayfa extends StatefulWidget {
  final Urunler urun;

  const DetaySayfa({super.key, required this.urun});

  @override
  _DetaySayfaState createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int adet = 1;

  @override
  void initState() {
    super.initState();
    context.read<SepetCubit>().sepettekiUrunleriYukle("ozlem_sevinc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  "http://kasimadalan.pe.hu/urunler/resimler/${widget.urun.resim}",
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 25),

                Text(
                  widget.urun.ad,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  "Marka: ${widget.urun.marka}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 25),
                Text("${widget.urun.fiyat} ₺", style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Adet: ", style: TextStyle(fontSize: 16)),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (adet > 1) adet--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF116980),
                        foregroundColor:Colors.white,
                      ),
                      child: const Text("-",style: TextStyle(fontSize: 28),),
                    ),
                    const SizedBox(width: 15),
                    Text("$adet", style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          adet++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF116980),
                        foregroundColor:Colors.white,
                      ),
                      child: const Text("+",style: TextStyle(fontSize: 28),),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
              child: BlocBuilder<SepetCubit, List<SepetUrunler>>(
                builder: (context, sepet) {
                  return Container(
                    color: Color(0xFF116980),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Toplam Fiyat: ${widget.urun.fiyat * adet} ₺",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 500,
                          child: ElevatedButton(
                            onPressed: () {
                              final varOlanUrun = sepet.firstWhere(
                                    (item) => item.ad == widget.urun.ad,
                                orElse: () => SepetUrunler(
                                  sepetId: -1,
                                  ad: '',
                                  resim: '',
                                  kategori: '',
                                  fiyat: 0,
                                  marka: '',
                                  siparisAdeti: 0,
                                  kullaniciAdi: '',
                                ),
                              );

                              if (varOlanUrun.sepetId != -1) {
                                context.read<SepetCubit>().sepettenUrunSil(
                                  sepetId: varOlanUrun.sepetId,
                                  kullaniciAdi: "ozlem_sevinc",
                                );

                                final guncelAdet = varOlanUrun.siparisAdeti + adet;

                                context.read<SepetCubit>().sepeteUrunEkle(
                                  ad: widget.urun.ad,
                                  resim: widget.urun.resim,
                                  kategori: widget.urun.kategori,
                                  fiyat: widget.urun.fiyat,
                                  marka: widget.urun.marka,
                                  siparisAdeti: guncelAdet,
                                  kullaniciAdi: "ozlem_sevinc",
                                );
                              } else {
                                context.read<SepetCubit>().sepeteUrunEkle(
                                  ad: widget.urun.ad,
                                  resim: widget.urun.resim,
                                  kategori: widget.urun.kategori,
                                  fiyat: widget.urun.fiyat,
                                  marka: widget.urun.marka,
                                  siparisAdeti: adet,
                                  kullaniciAdi: "ozlem_sevinc",
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Ürün sepete eklendi"))
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Colors.white,
                              foregroundColor:Color(0xFF116980),
                            ),
                            child: const Text("Sepete Ekle"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
