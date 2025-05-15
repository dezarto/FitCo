import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class diet_page extends StatefulWidget {
  const diet_page({super.key});

  @override
  _diet_page createState() => _diet_page();
}

class _diet_page extends State<diet_page> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _breakfastController = TextEditingController();
  TextEditingController _snack1Controller = TextEditingController();
  TextEditingController _lunchController = TextEditingController();

  TextEditingController _snack2Controller = TextEditingController();
  TextEditingController _dinnerController = TextEditingController();
  TextEditingController _snack3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'İlan Bilgileri',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Breakfast:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _breakfastController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'First Snack:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _snack1Controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lunch:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lunchController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'second snack :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _snack2Controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fiyat:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dinnerController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Third Snack:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _snack3Controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir yiyecek girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Lütfen bir yiyecek girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      saveDataToFirestore(_breakfastController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Arka plan rengi
                    ),
                    child: const Text(
                      'programı kaydet',
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

  saveDataToFirestore(String packageName) async {
    String? mailAddress = MailService.mailValue;

    String breakfastController = _breakfastController.text;
    String snack1Controller = _snack1Controller.text;
    String lunchController = _lunchController.text;
    String snack2Controller = _snack2Controller.text;
    String dinnerController = _dinnerController.text;
    String snack3Controller = _snack3Controller.text;

    if (mailAddress != null) {
      final dietDocRef = await DatabaseService.DietCoachsRef(mailAddress);

      dietDocRef.set({
        "breakfast": breakfastController,
        "snack1": snack1Controller,
        "lunch": lunchController,
        "snack2": snack2Controller,
        "dinner": dinnerController,
        "snack3": snack3Controller,
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
    _breakfastController.dispose();
    _snack1Controller.dispose();
    _lunchController.dispose();
    _snack2Controller.dispose();
    _dinnerController.dispose();

    _snack3Controller.dispose();

    super.dispose();
  }
}
