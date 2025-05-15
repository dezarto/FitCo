import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeasurementsInsidePage extends StatefulWidget {
  final String? measurementDate;

  const MeasurementsInsidePage({super.key, this.measurementDate});

  @override
  _MeasurementsInsidePageState createState() => _MeasurementsInsidePageState();
}

class _MeasurementsInsidePageState extends State<MeasurementsInsidePage> {
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
      _fetchMeasurementData();
    }
  }

  Future<void> _fetchMeasurementData() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      try {
        final measurementsDocRef =
        await DatabaseService.measurementsRef(mailAddress);
        DocumentSnapshot snapshot =
        await measurementsDocRef.doc(widget.measurementDate).get();
        if (snapshot.exists) {
          setState(() {
            _weightController.text = snapshot['weight'];
            _heightController.text = snapshot['height'];
            _bmiController.text = snapshot['bmi'];
            _waistController.text = snapshot['waist'];
            _chestController.text = snapshot['chest'];
            _armController.text = snapshot['arm'];
            _legController.text = snapshot['leg'];
            _muscleMassController.text = snapshot['muscle'];
            _bodyFatController.text = snapshot['body'];
          });
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    } else {
      print("Mail address is null: MeasurementsInsidePage.dart");
    }
  }

  String generateDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return formattedDate;
  }

  void saveDataToFirestore() async {
    String? mailAddress = MailService.mailValue;
    String weightController = _weightController.text;
    String heightController = _heightController.text;
    String bmiController = _bmiController.text;
    String waistController = _waistController.text;
    String chestController = _chestController.text;
    String armController = _armController.text;
    String legController = _legController.text;
    String muscleMassController = _muscleMassController.text;
    String bodyFatController = _bodyFatController.text;
    if (mailAddress != null) {
      final measurementsDocRef =
      await DatabaseService.measurementsRef(mailAddress);
      DocumentReference measurementsInsideDocRef =
      measurementsDocRef.doc(widget.measurementDate ?? generateDate());
      measurementsInsideDocRef.set({
        "weight": weightController,
        "height": heightController,
        "bmi": bmiController,
        "waist": waistController,
        "chest": chestController,
        "arm": armController,
        "leg": legController,
        "muscle": muscleMassController,
        "body": bodyFatController,
      }).then((value) {
        print("Data saved.");
      }).catchError((error) {
        print("Something went wrong!: $error");
      });
    } else {
      print("Mail adresi tanımsız hata: MeasurementsInsidePage.dart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Measurements Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kilo (kg)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kilonuzu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Boy (cm)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen boyunuzu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bmiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Vücut Kitle İndeksi (BMI)",
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bel Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Göğüs Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _armController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kol Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _legController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bacak Çevresi (cm)",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _muscleMassController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kas Kütlesi (kg)",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyFatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Vücut Yağ Oranı (%)",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveDataToFirestore();
                },
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}