import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Views/ChatView/ContactPage.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachPurchasedUsersPage.dart';
import 'package:fitness_app/Views/HomeView/HomePage.dart';
import 'package:fitness_app/Views/MyAccountView/MyAccount.dart';
import 'package:fitness_app/Views/CoachView/advertisePage.dart';
import 'package:fitness_app/Views/WhatchTheProgramView/watchTheProgram.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarComponent extends StatefulWidget {
  const BottomNavigationBarComponent({super.key});

  @override
  State<BottomNavigationBarComponent> createState() =>
      _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState
    extends State<BottomNavigationBarComponent> {
  String? mailAddress = MailService.mailValue;
  bool controller = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsCoach();
  }

  Future<void> _checkIfUserIsCoach() async {
    if (mailAddress != null) {
      controller = await userChecker(mailAddress!);
      setState(() {}); // UI'ı güncelle
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == false) {
      return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.movie),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WatchTheProgram()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccount()),
                );
              },
            ),
          ],
        ),
      );
    } else if (controller == true) {
      // Koç
      return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CoachPurchasedUsersPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdvertisePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccount()),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<bool> userChecker(String mailAddress) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      final snapshotUser =
          await _firestore.collection('Users').doc(mailAddress).get();
      if (snapshotUser.exists) {
        return false; // Kullanıcı bulundu
      }

      final snapshotCoaches =
          await _firestore.collection('Coaches').doc(mailAddress).get();
      if (snapshotCoaches.exists) {
        return true; // Koç bulundu
      }

      return false;
    } catch (e) {
      print("Firestore'da email kontrolünde hata: $e");
      return false;
    }
  }
}
