import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Views/MyAccountView/SupportPage.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/Views/LoginView/loginPage.dart';
import 'package:fitness_app/Views/MyAccountView/SettingPage.dart';
import 'package:fitness_app/Views/MyAccountView/memberinformation.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
class MyAccount extends StatefulWidget {
  const MyAccount({Key? key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? mailAddress = MailService.mailValue;

  bool? isCoach;
  @override
  void initState() {
    super.initState();
    _checkIfUserIsCoach();
  }

  Future<void> _checkIfUserIsCoach() async {
    if (mailAddress != null) {
      isCoach = await MailService.userChecker(mailAddress!);
      if (isCoach != null) {
        MailService.loadData(); // Load user data from MailService
      } else {
        print("Error determining user type: MyAccount.dart");
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'My account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 35, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MailService.profilePictureURL != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(MailService.profilePictureURL!),
                radius: 70,
              )
                  : const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/images/Sky_Blue.png'),
                radius: 70,
              ),
              const SizedBox(height: 20),
              Text(
                '${MailService.name ?? 'Null'} ${MailService.surname ?? 'Null'}',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberInformation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.red,
                  minimumSize: Size(160, 50),
                ),
                child: const Text(
                  'My Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.red,
                  minimumSize: Size(160, 50),
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.red,
                  minimumSize: const Size(160, 50),
                ),
                child: const Text(
                  'Support',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.red,
                  minimumSize: const Size(160, 50),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarComponent(),
      ),
    );
  }
}