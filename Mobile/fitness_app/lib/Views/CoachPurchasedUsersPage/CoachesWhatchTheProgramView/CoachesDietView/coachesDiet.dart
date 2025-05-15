import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesDietView/coachesManageDiet.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';

class CoachesDiet extends StatefulWidget {
  final String userEmail;
  const CoachesDiet({super.key, required this.userEmail});

  @override
  _CoachesDietState createState() => _CoachesDietState();
}

class _CoachesDietState extends State<CoachesDiet> {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference finessAppProjectRef;
  late CollectionReference userRef;
  List<Map<String, String>> _diyetList = [];

  @override
  void initState() {
    super.initState();
    _fetchDiyetData(widget.userEmail);
  }

  Future<void> _fetchDiyetData(String userEmail) async {
    final dietDocRef = await DatabaseService.dietRef(userEmail);
    DocumentSnapshot snapshot = await dietDocRef.get();
    setState(() {
      _diyetList.add({"Kahvalti": snapshot["breakfast"] ?? ""});
      _diyetList.add({"Ara1": snapshot["snack1"] ?? ""});
      _diyetList.add({"Oglen": snapshot["lunch"] ?? ""});
      _diyetList.add({"Ara2": snapshot["snack2"] ?? ""});
      _diyetList.add({"Aksam": snapshot["dinner"] ?? ""});
      _diyetList.add({"Ara3": snapshot["snack3"] ?? ""});
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Diyet Listesi';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title
          ),

        ),
        body: ListView.builder(
          itemCount: _diyetList.length,
          itemBuilder: (context, index) {
            final meal = _diyetList[index];
            final key = meal.keys.first;
            final value = meal[key];
            return _buildCard(key, value ?? "");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CoachesManageDiet(userEmail: widget.userEmail),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(),
      ),
    );
  }

  Widget _buildCard(String key, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                _leadingIcon(key),
                SizedBox(width: 16),
                Text(
                  key,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Icon _leadingIcon(String key) {
    switch (key) {
      case "Kahvalti":
        return Icon(Icons.breakfast_dining);
      case "Ara1":
      case "Ara2":
      case "Ara3":
        return Icon(Icons.apple);
      case "Oglen":
        return Icon(Icons.lunch_dining);
      case "Aksam":
        return Icon(Icons.dinner_dining);
      default:
        return Icon(Icons.error);
    }
  }
}