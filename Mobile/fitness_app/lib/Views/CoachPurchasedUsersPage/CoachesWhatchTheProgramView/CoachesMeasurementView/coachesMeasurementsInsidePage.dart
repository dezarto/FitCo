import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoachesMeasurementsInsidePage extends StatefulWidget {
  final String userEmail;
  final String? measurementDate; // To differentiate between new & existing data
  const CoachesMeasurementsInsidePage({
    super.key,
    required this.userEmail,
    this.measurementDate,
  });

  @override
  _CoachesMeasurementsInsidePageState createState() =>
      _CoachesMeasurementsInsidePageState();
}

class _CoachesMeasurementsInsidePageState
    extends State<CoachesMeasurementsInsidePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _armController = TextEditingController();
  final TextEditingController _legController = TextEditingController();
  final TextEditingController _muscleMassController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.measurementDate != null) {
      _fetchExistingMeasurements();
    }
  }

  Future<void> _fetchExistingMeasurements() async {
    try {
      final measurementsDocRef =
      await DatabaseService.measurementsRef(widget.userEmail);
      DocumentSnapshot snapshot =
      await measurementsDocRef.doc(widget.measurementDate).get();

      if (snapshot.exists) {
        setState(() {
          _weightController.text = snapshot.get("weight") ?? '';
          _heightController.text = snapshot.get("height") ?? '';
          _bmiController.text = snapshot.get("bmi") ?? '';
          _waistController.text = snapshot.get("waist") ?? '';
          _chestController.text = snapshot.get("chest") ?? '';
          _armController.text = snapshot.get("arm") ?? '';
          _legController.text = snapshot.get("leg") ?? '';
          _muscleMassController.text = snapshot.get("muscle") ?? '';
          _bodyFatController.text = snapshot.get("body") ?? '';
        });
      }
    } catch (e) {
      print("Error fetching existing measurements: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.measurementDate != null
              ? "Ölçümleri Düzenle"
              : "Yeni Ölçüm Ekle",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
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
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Kilo
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kilo (kg)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kiloyu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Boy
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Boy (cm)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen boyu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Vücut Kitle İndeksi (BMI)
              TextFormField(
                controller: _bmiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Vücut Kitle İndeksi (BMI)",
                ),
              ),
              const SizedBox(height: 40),
              // Bel Çevresi
              TextFormField(
                controller: _waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bel Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              // Göğüs Çevresi
              TextFormField(
                controller: _chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Göğüs Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              // Kol Çevresi
              TextFormField(
                controller: _armController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kol Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              // Bacak Çevresi
              TextFormField(
                controller: _legController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bacak Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              // Kas Kütlesi
              TextFormField(
                controller: _muscleMassController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kas Kütlesi (kg)",
                ),
              ),
              const SizedBox(height: 10),
              // Vücut Yağ Oranı
              TextFormField(
                controller: _bodyFatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Vücut Yağ Oranı (%)",
                ),
              ),
              SizedBox(height: 20),
              // Kaydet Butonu
              ElevatedButton(
                onPressed: () {
                  saveDataToFirestore();
                },
                child: Text(
                    widget.measurementDate != null ? "Güncelle" : 'Kaydet'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }

  String generateDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return formattedDate;
  }

  void saveDataToFirestore() async {
    String weight = _weightController.text;
    String height = _heightController.text;
    String bmi = _bmiController.text;
    String waist = _waistController.text;
    String chest = _chestController.text;
    String arm = _armController.text;
    String leg = _legController.text;
    String muscle = _muscleMassController.text;
    String body = _bodyFatController.text;

    try {
      final measurementsDocRef =
      await DatabaseService.measurementsRef(widget.userEmail);
      final documentRef = measurementsDocRef.doc(
          widget.measurementDate ?? generateDate()); // Use existing or new date

      await documentRef.set({
        "weight": weight,
        "height": height,
        "bmi": bmi,
        "waist": waist,
        "chest": chest,
        "arm": arm,
        "leg": leg,
        "muscle": muscle,
        "body": body,
      });

      // Show a success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ölçümler başarıyla kaydedildi.")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error saving data to Firestore: $e");
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ölçümler kaydedilirken hata oluştu.")),
      );
    }
  }
}