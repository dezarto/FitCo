import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesMeasurementView/coachesMeasurementsInsidePage.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';

class CoachesMeasurementPage extends StatefulWidget {
  final String userEmail; // Add userEmail as a parameter
  const CoachesMeasurementPage({super.key, required this.userEmail});

  @override
  State<CoachesMeasurementPage> createState() => _CoachesMeasurementPageState();
}

class _CoachesMeasurementPageState extends State<CoachesMeasurementPage> {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _finessAppProjectRef;
  late CollectionReference _userRef;
  List<String> _measurementDates = [];

  @override
  void initState() {
    super.initState();
    _fetchMeasurementDates(widget.userEmail);
  }

  Future<void> _fetchMeasurementDates(String userEmail) async {
    if (userEmail != null) {
      try {
        final measurementsDocRef =
        await DatabaseService.measurementsRef(userEmail);
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
          'Ölçümler',
          style: TextStyle(
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
                  builder: (context) => CoachesMeasurementsInsidePage(
                    userEmail: widget.userEmail,
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
              builder: (context) => CoachesMeasurementsInsidePage(
                userEmail: widget.userEmail,
                measurementDate: null, // Pass null for new measurement
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}