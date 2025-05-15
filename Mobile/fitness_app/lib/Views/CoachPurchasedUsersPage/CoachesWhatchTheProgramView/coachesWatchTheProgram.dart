import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesDietView/coachesDiet.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesMeasurementView/coachesMeasurementPage.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/CoachesTrainingView/coachesTrainingPage.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';

class CoachesWatchTheProgram extends StatefulWidget {
  final String userEmail; // userEmail parametresini ekleyin

  const CoachesWatchTheProgram({super.key, required this.userEmail}); // Parametreyi yapıcıya ekleyin

  @override
  State<CoachesWatchTheProgram> createState() => _CoachesWatchTheProgramState();
}

class _CoachesWatchTheProgramState extends State<CoachesWatchTheProgram> {


  @override
  void initState() {
    super.initState();
    print("Deneme: ");
    print(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Watch The your Program",
          style: TextStyle(
            color: Colors.white,
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
        backgroundColor: Colors.transparent, // backgroundColor transparan yapılmalı
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      'lib/assets/images/dietary_programs.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => CoachesDiet(userEmail: widget.userEmail)),
                      );
                    },
                    child: Text(
                      'Go Dietary program',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      'lib/assets/images/trainingProgram.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoachesTrainingPage(userEmail: widget.userEmail)),
                      );
                    },
                    child: Text(
                      'Go Training program',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      'lib/assets/images/bodyMeasurements.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoachesMeasurementPage(userEmail: widget.userEmail)),
                      );
                    },
                    child: Text(
                      'Go Body Measurements',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}
