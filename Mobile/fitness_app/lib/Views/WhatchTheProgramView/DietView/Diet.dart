import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference finessAppProjectRef;
  late CollectionReference userRef;
  List<Map<String, String>> _diyetList = [];

  @override
  void initState() {
    super.initState();
    _fetchDiyetData();
  }

  Future<void> _fetchDiyetData() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      final dietDocRef = await DatabaseService.dietRef(mailAddress);
      DocumentSnapshot snapshot = await dietDocRef.get();
      setState(() {
        _diyetList.add({"Kahvaltı": snapshot["breakfast"] ?? ""});
        _diyetList.add({"Ara Öğün 1": snapshot["snack1"] ?? ""});
        _diyetList.add({"Öğle Yemeği": snapshot["lunch"] ?? ""});
        _diyetList.add({"Ara Öğün 2": snapshot["snack2"] ?? ""});
        _diyetList.add({"Akşam Yemeği": snapshot["dinner"] ?? ""});
        _diyetList.add({"Ara Öğün 3": snapshot["snack3"] ?? ""});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Diyet Listesi';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
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
        body: _diyetList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _diyetList.length,
                itemBuilder: (context, index) {
                  String key = _diyetList[index].keys.first;
                  String value = _diyetList[index][key]!;
                  return _buildCard(key, value);
                },
              ),
        bottomNavigationBar: const BottomNavigationBarComponent(),
      ),
    );
  }

  Widget _buildCard(String key, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Yuvarlatılmış köşeler
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor('#c1bcc4'),
              HexColor('#c1bcc4')
            ], // Açık yeşilden koyu yeşile gradyan
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16), // Yuvarlatılmış köşeler
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _leadingIcon(key),
                const SizedBox(width: 12),
                Text(
                  key,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Icon _leadingIcon(String key) {
    switch (key) {
      case "Kahvaltı":
        return const Icon(Icons.breakfast_dining, color: Colors.white);
      case "Ara Öğün 1":
      case "Ara Öğün 2":
      case "Ara Öğün 3":
        return const Icon(Icons.apple, color: Colors.white);
      case "Öğle Yemeği":
        return const Icon(Icons.lunch_dining, color: Colors.white);
      case "Akşam Yemeği":
        return const Icon(Icons.dinner_dining, color: Colors.white);
      default:
        return const Icon(Icons.error, color: Colors.white);
    }
  }
}
