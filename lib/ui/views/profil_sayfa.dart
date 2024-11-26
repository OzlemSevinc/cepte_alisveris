import 'package:flutter/material.dart';

class ProfilSayfa extends StatefulWidget {
  const ProfilSayfa({super.key});

  @override
  State<ProfilSayfa> createState() => _ProfilSayfaState();
}

class _ProfilSayfaState extends State<ProfilSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim",style: TextStyle(color: Colors.white),),
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
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Icon(Icons.account_circle, size: 100, color: Colors.white),
              SizedBox(height: 16),
              Text(
                "ozlem_sevinc",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
