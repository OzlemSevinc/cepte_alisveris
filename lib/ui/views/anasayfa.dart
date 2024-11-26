import 'package:cepte_alisveris/ui/views/profil_sayfa.dart';
import 'package:cepte_alisveris/ui/views/sepet_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cepte_alisveris/data/entity/urunler.dart';
import 'package:cepte_alisveris/ui/cubit/urunler_cubit.dart';
import 'package:cepte_alisveris/ui/views/detay_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final TextEditingController searchController = TextEditingController();
  String seciliSiralama = "Önerilen";
  String seciliFiltre = "Tümü";

  @override
  void initState() {
    super.initState();
    context.read<UrunlerCubit>().tumUrunleriYukle();
  }

  void urunAra(String aramaKelimesi) {
    context.read<UrunlerCubit>().ara(aramaKelimesi);
  }

  void siralamaVeFiltrelemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        String geciciSiralama = seciliSiralama;
        String geciciFiltre = seciliFiltre;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sırala",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ListTile(
                    title: const Text("Önerilen"),
                    trailing: geciciSiralama == "Önerilen"
                        ? const Icon(Icons.check, color: Color(0xFF116980),)
                        : null,
                    onTap: () => setState(() => geciciSiralama = "Önerilen"),
                  ),
                  ListTile(
                    title: const Text("A-Z"),
                    trailing: geciciSiralama == "A-Z"
                        ? const Icon(Icons.check, color: Color(0xFF116980),)
                        : null,
                    onTap: () => setState(() => geciciSiralama = "A-Z"),
                  ),
                  ListTile(
                    title: const Text("Z-A"),
                    trailing: geciciSiralama == "Z-A"
                        ? const Icon(Icons.check, color: Color(0xFF116980),)
                        : null,
                    onTap: () => setState(() => geciciSiralama = "Z-A"),
                  ),
                  ListTile(
                    title: const Text("Artan Fiyat"),
                    trailing: geciciSiralama == "Artan Fiyat"
                        ? const Icon(Icons.check, color: Color(0xFF116980),)
                        : null,
                    onTap: () => setState(() => geciciSiralama = "Artan Fiyat"),
                  ),
                  ListTile(
                    title: const Text("Azalan Fiyat"),
                    trailing: geciciSiralama == "Azalan Fiyat"
                        ? const Icon(Icons.check, color: Color(0xFF116980),)
                        : null,
                    onTap: () => setState(() => geciciSiralama = "Azalan Fiyat"),
                  ),
                  const Text(
                    "Filtrele",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: geciciFiltre,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "Tümü", child: Text("Tümü")),
                      DropdownMenuItem(value: "Teknoloji", child: Text("Teknoloji")),
                      DropdownMenuItem(value: "Kozmetik", child: Text("Kozmetik")),
                      DropdownMenuItem(value: "Aksesuar", child: Text("Aksesuar")),
                    ],
                    onChanged: (value) => setState(() {
                      if (value != null) geciciFiltre = value;
                    }),
                  ),
                  SizedBox(
                    width: 500,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          seciliSiralama = geciciSiralama;
                          seciliFiltre = geciciFiltre;
                        });
                        context.read<UrunlerCubit>().filtrele(seciliFiltre);
                        context.read<UrunlerCubit>().sirala(seciliSiralama);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF116980),
                        foregroundColor:Colors.white,
                      ),
                      child: const Text("Uygula"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cepte Alışveriş",
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Ara...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white
                      ),
                      onChanged: (value) => context.read<UrunlerCubit>().ara(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list,color: Colors.white,),
                    onPressed: siralamaVeFiltrelemeBottomSheet,
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<UrunlerCubit, List<Urunler>>(
                builder: (context, urunlerListesi) {
                  if (urunlerListesi.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: urunlerListesi.length,
                    itemBuilder: (context, index) {
                      final urun = urunlerListesi[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetaySayfa(urun: urun),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Column(
                            children: [
                              Image.network(
                                "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Text(urun.ad, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                              Text("${urun.fiyat} ₺", style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profilim",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Sepetim",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Anasayfa(),
              ),
            );
          }else if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilSayfa(),
              ),
            );
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SepetSayfa(kullaniciAdi: "ozlem_sevinc"),
              ),
            );
          }
        },
        selectedItemColor: Color(0xFF116980),
      ),
    );
  }
}
