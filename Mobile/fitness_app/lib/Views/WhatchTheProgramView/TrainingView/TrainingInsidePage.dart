import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingInsidePage extends StatefulWidget {
  final String trainingDate;

  const TrainingInsidePage({Key? key, required this.trainingDate})
      : super(key: key);

  @override
  _TrainingInsidePageState createState() => _TrainingInsidePageState();
}

class _TrainingInsidePageState extends State<TrainingInsidePage> {
  final _firestore = FirebaseFirestore.instance;
  late DocumentReference _trainingRef;
  Map<String, dynamic>? _trainingData;

  @override
  void initState() {
    super.initState();
    _fetchTrainingData();
  }

  Future<void> _fetchTrainingData() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      try {
        final _trainingRef = await DatabaseService.trainingRef(mailAddress);
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _trainingRef
            .doc(widget.trainingDate)
            .get() as DocumentSnapshot<Map<String, dynamic>>;
        setState(() {
          _trainingData = snapshot.data();
        });
      } catch (e) {
        print("Error fetching training data: $e");
      }
    } else {
      print("Mail address is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(
          currentDate,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            // Gün İçin Not (Varsa)
            if (_trainingData?['trainingNote'] != null)
              _buildRegionTile(
                  "Not",
                  _trainingData?['trainingNote'],
                  null,
                  null,
                  null
              ),
            SizedBox(height: 20.0),
            // 1. Çalışılacak Bölge
            _buildRegionTile(
              "1. Çalışılacak Bölge",
              _trainingData?['region1'],
              _trainingData?['exercise1_1'],
              _trainingData?['exercise1_2'],
              _trainingData?['exercise1_3'],
            ),
            SizedBox(height: 20.0),
            // 2. Çalışılacak Bölge
            _buildRegionTile(
              "2. Çalışılacak Bölge",
              _trainingData?['region2'],
              _trainingData?['exercise2_1'],
              _trainingData?['exercise2_2'],
              _trainingData?['exercise2_3'],
            ),
            SizedBox(height: 20.0),
            // 3. Çalışılacak Bölge
            _buildRegionTile(
              "3. Çalışılacak Bölge",
              _trainingData?['region3'],
              _trainingData?['exercise3_1'],
              _trainingData?['exercise3_2'],
              _trainingData?['exercise3_3'],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }

  // _buildRegionTile fonksiyonunu CoachesTrainingInsidePage'den kopyalayın
  Widget _buildRegionTile(String title, dynamic regionName, dynamic exercise1,
      dynamic exercise2, dynamic exercise3) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          // Bölge Adı
          if (regionName != null)
            Text(
              regionName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          SizedBox(height: 10),
          // Hareketler
          if (exercise1 != null)
            Text(
              exercise1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          if (exercise2 != null)
            Text(
              exercise2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          if (exercise3 != null)
            Text(
              exercise3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}