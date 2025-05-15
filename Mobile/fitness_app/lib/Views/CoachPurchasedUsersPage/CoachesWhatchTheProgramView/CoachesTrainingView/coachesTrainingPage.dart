import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesTrainingView/coachesAddTrainingPage.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesTrainingView/coachesTrainingInsidePage.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoachesTrainingPage extends StatefulWidget {
  final String userEmail;

  const CoachesTrainingPage({super.key, required this.userEmail});

  @override
  _CoachesTrainingPageState createState() => _CoachesTrainingPageState();
}

class _CoachesTrainingPageState extends State<CoachesTrainingPage> {
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
        final trainingsDocRef = await DatabaseService.trainingRef(widget.userEmail);
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
        backgroundColor: Colors.red[600],
        title: Text(
          currentDate,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout işlemi burada gerçekleştirilebilir
            },
            tooltip: 'Logout',
          ),
          Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red[600],
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTile("Full"),
                    SizedBox(width: 20.0),
                    _buildTile("Motive"),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildContent("3"),
                    SizedBox(width: 20.0),
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
                        builder: (context) => CoachesTrainingInsidePage(
                          trainingDate: _trainingDates[index], // Tarih gönderiliyor
                          userEmail: widget.userEmail, // Kullanıcı e-postası gönderiliyor
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CoachesAddTrainingPage(userEmail: widget.userEmail),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }

  Widget _buildTile(String title) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
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
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}