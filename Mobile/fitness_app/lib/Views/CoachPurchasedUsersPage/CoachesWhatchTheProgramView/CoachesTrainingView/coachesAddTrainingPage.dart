import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class CoachesAddTrainingPage extends StatefulWidget {
  final String userEmail;
  const CoachesAddTrainingPage({super.key, required this.userEmail});

  @override
  _CoachesAddTrainingPageState createState() =>
      _CoachesAddTrainingPageState();
}

class _CoachesAddTrainingPageState extends State<CoachesAddTrainingPage> {
  final _formKey = GlobalKey<FormState>();

  // Bölge ve Hareket Adları için Controller'lar
  TextEditingController _dayController = TextEditingController();
  TextEditingController _region1Controller = TextEditingController();
  TextEditingController _exercise1_1Controller = TextEditingController();
  TextEditingController _exercise1_2Controller = TextEditingController();
  TextEditingController _exercise1_3Controller = TextEditingController();
  TextEditingController _region2Controller = TextEditingController();
  TextEditingController _exercise2_1Controller = TextEditingController();
  TextEditingController _exercise2_2Controller = TextEditingController();
  TextEditingController _exercise2_3Controller = TextEditingController();
  TextEditingController _region3Controller = TextEditingController();
  TextEditingController _exercise3_1Controller = TextEditingController();
  TextEditingController _exercise3_2Controller = TextEditingController();
  TextEditingController _exercise3_3Controller = TextEditingController();

  // Not İçin Controller
  TextEditingController _trainingNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Eğitim Bilgileri',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // backgroundColor transparan yapılmalı
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Gün belirleme
                const Text(
                  'Gün belirle: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dayController,
                  decoration: const InputDecoration(
                    hintText: 'Gün belirle',
                    border: OutlineInputBorder(),
                  ),
                ),
                // Not Alanı
                const Text(
                  'Not:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _trainingNoteController,
                  decoration: const InputDecoration(
                    hintText: 'Lütfen öğrencinizi ekstra bilgilendiriniz',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 100,),
                // 1. Bölge
                const Text(
                  '1. Çalışılacak Bölge:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _region1Controller,
                  decoration: const InputDecoration(
                    hintText: '1. Çalışılacak Bölge',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '1. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise1_1Controller,
                  decoration: const InputDecoration(
                    hintText: '1. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '2. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise1_2Controller,
                  decoration: const InputDecoration(
                    hintText: '2. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '3. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise1_3Controller,
                  decoration: const InputDecoration(
                    hintText: '3. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 100,),
                // 2. Bölge
                const Text(
                  '2. Çalışılacak Bölge:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _region2Controller,
                  decoration: const InputDecoration(
                    hintText: '2. Çalışılacak Bölge',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '1. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise2_1Controller,
                  decoration: const InputDecoration(
                    hintText: '1. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '2. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise2_2Controller,
                  decoration: const InputDecoration(
                    hintText: '2. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '3. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise2_3Controller,
                  decoration: const InputDecoration(
                    hintText: '3. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 100,),
                // 3. Bölge
                const Text(
                  '3. Çalışılacak Bölge:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _region3Controller,
                  decoration: const InputDecoration(
                    hintText: '3. Çalışılacak Bölge',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '1. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise3_1Controller,
                  decoration: const InputDecoration(
                    hintText: '1. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '2. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise3_2Controller,
                  decoration: const InputDecoration(
                    hintText: '2. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '3. Hareket adı ve set sayısı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _exercise3_3Controller,
                  decoration: const InputDecoration(
                    hintText: '3. Hareket adı ve set sayısı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      saveDataToFirestore();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Arka plan rengi
                    ),
                    child: const Text(
                      'Eğitimi Kaydet',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }

  saveDataToFirestore() async {
    if (widget.userEmail != null) {
      final trainingCollectionRef =
      await DatabaseService.trainingRef(widget.userEmail);

      // Create a DocumentReference with a unique ID (e.g., using a timestamp)
      final newTrainingDocRef = trainingCollectionRef.doc(_dayController.text); // Get a DocumentReference

      newTrainingDocRef.set({
        "trainingNote": _trainingNoteController.text,

        // 1. Bölge
        "region1": _region1Controller.text,
        "exercise1_1": _exercise1_1Controller.text,
        "exercise1_2": _exercise1_2Controller.text,
        "exercise1_3": _exercise1_3Controller.text,

        // 2. Bölge
        "region2": _region2Controller.text,
        "exercise2_1": _exercise2_1Controller.text,
        "exercise2_2": _exercise2_2Controller.text,
        "exercise2_3": _exercise2_3Controller.text,

        // 3. Bölge
        "region3": _region3Controller.text,
        "exercise3_1": _exercise3_1Controller.text,
        "exercise3_2": _exercise3_2Controller.text,
        "exercise3_3": _exercise3_3Controller.text,
      }).then((value) {
        print("Data saved.");
      }).catchError((error) {
        print("Something went wrong!: $error");
      });
    } else {
      print("Mail adresi tanımsız hata: advertiseInformation.dart");
    }
  }

  @override
  void dispose() {
    // Sayfa kapatıldığında controller'ları temizleme
    _trainingNoteController.dispose();
    _region1Controller.dispose();
    _exercise1_1Controller.dispose();
    _exercise1_2Controller.dispose();
    _exercise1_3Controller.dispose();
    _region2Controller.dispose();
    _exercise2_1Controller.dispose();
    _exercise2_2Controller.dispose();
    _exercise2_3Controller.dispose();
    _region3Controller.dispose();
    _exercise3_1Controller.dispose();
    _exercise3_2Controller.dispose();
    _exercise3_3Controller.dispose();

    super.dispose();
  }
}