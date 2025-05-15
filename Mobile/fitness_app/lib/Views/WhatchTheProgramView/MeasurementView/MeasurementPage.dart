import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/WhatchTheProgramView/MeasurementView/MeasurementsInsidePage.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _fitnessAppProjectRef;
  late CollectionReference _userRef;
  List<String> _measurementDates = [];

  @override
  void initState() {
    super.initState();
    _fetchMeasurementDates();
  }

  Future<void> _fetchMeasurementDates() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      try {
        final measurementsDocRef =
        await DatabaseService.measurementsRef(mailAddress);
        QuerySnapshot snapshot = await measurementsDocRef.get();
        setState(() {
          _measurementDates = snapshot.docs.map((doc) => doc.id).toList();
        });
      } catch (e) {
        print("Error fetching data: $e");
      }
    } else {
      print("Mail address is null: MeasurementsInsidePage.dart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Measurements",
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
      body: ListView.builder(
        itemCount: _measurementDates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_measurementDates[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeasurementsInsidePage(
                    measurementDate: _measurementDates[index],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeasurementsInsidePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}