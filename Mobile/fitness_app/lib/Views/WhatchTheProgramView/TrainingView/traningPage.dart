import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'TrainingInsidePage.dart'; // TrainingInsidePage dosyasının içeri aktarılması

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _finessAppProjectRef;
  late CollectionReference _userRef;
  List<String> _trainingDates = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainingDates();
  }

  Future<void> _fetchTrainingDates() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      try {
        final trainingsDocRef = await DatabaseService.trainingRef(mailAddress);
        QuerySnapshot snapshot = await trainingsDocRef.get();
        setState(() {
          _trainingDates = snapshot.docs.map((doc) => doc.id).toList();
        });
      } catch (e) {
        // Handle potential errors (e.g., display an error message)
        print("Error fetching data: $e");
      }
    } else {
      print("Mail address is null: TrainingInsidePage.dart");
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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
      body: Column(
        children: [
          Container(
            color: Colors.red[600],
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTile("Full"),
                    const SizedBox(width: 20.0),
                    _buildTile("Motive"),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContent("3"),
                    const SizedBox(width: 20.0),
                    _buildContent("456"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _trainingDates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_trainingDates[index]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingInsidePage(
                            trainingDate: _trainingDates[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }

  Widget _buildTile(String title) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String content) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
