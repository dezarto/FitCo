import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Views/CoachPurchasedUsersPage/CoachesWhatchTheProgramView/coachesWatchTheProgram.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class CoachPurchasedUsersPage extends StatefulWidget {
  const CoachPurchasedUsersPage({super.key});

  @override
  _CoachPurchasedUsersPageState createState() => _CoachPurchasedUsersPageState();
}

class _CoachPurchasedUsersPageState extends State<CoachPurchasedUsersPage> {
  String? mailAddress = MailService.mailValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Purchased Users",
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

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Coaches')
            .doc(mailAddress)
            .collection('purchasedItems')
            .doc("purchased")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> purchasedData = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> purchasedUsers = purchasedData.values.toList();

          if (purchasedUsers.isEmpty) {
            return const Center(child: Text("No purchased users found."));
          }

          return ListView.builder(
            itemCount: purchasedUsers.length,
            itemBuilder: (context, index) {
              final userEmail = purchasedUsers[index]['userEmail'] ?? '';
              final userName = purchasedUsers[index]['AdvertiseName'] ?? '';
              return ListTile(
                title: Text(userName),
                subtitle: Text(userEmail),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoachesWatchTheProgram(
                        userEmail: userEmail,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }
}



