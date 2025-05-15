import 'package:fitness_app/Views/WhatchTheProgramView/DietView/Diet.dart';
import 'package:fitness_app/Views/WhatchTheProgramView/MeasurementView/MeasurementPage.dart';
import 'package:fitness_app/Views/WhatchTheProgramView/TrainingView/traningPage.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';

class WatchTheProgram extends StatefulWidget {
  const WatchTheProgram({super.key});

  @override
  State<WatchTheProgram> createState() => _WatchTheProgramState();
}

class _WatchTheProgramState extends State<WatchTheProgram> {
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
                        MaterialPageRoute(builder: (context) => Diet()),
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
                        MaterialPageRoute(builder: (context) => TrainingPage()),
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
                            builder: (context) => MeasurementPage()),
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
