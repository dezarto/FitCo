import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Views/ChatView/chatScreen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String? mailAddress = MailService.mailValue;
  bool isCoach = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsCoach();
  }

  Future<void> _checkIfUserIsCoach() async {
    if (mailAddress != null) {
      isCoach = await userChecker(mailAddress!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: isCoach
            ? FirebaseFirestore.instance
                .collection('Users')
                .where('email', isNotEqualTo: currentUserEmail)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('Coaches')
                .where('email', isNotEqualTo: currentUserEmail)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index].data() as Map<String, dynamic>;
                final email = user['email'];
                return FutureBuilder<DocumentSnapshot>(
                  future: _getInformationFuture(email),
                  builder: (context, infoSnapshot) {
                    if (infoSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (infoSnapshot.hasError) {
                      return Center(
                          child:
                              Text('Error: ${infoSnapshot.error.toString()}'));
                    } else {
                      final name = infoSnapshot.data!['name'];
                      final profilePictureURL =
                          infoSnapshot.data!['profilePictureURL'];
                      return FutureBuilder<int>(
                          future:
                              _getUnreadMessageCount(currentUserEmail!, email),
                          // Okunmamış mesaj sayısını al
                          builder: (context, unreadCountSnapshot) {
                            if (unreadCountSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (unreadCountSnapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${unreadCountSnapshot.error.toString()}'));
                            } else {
                              final unreadCount =
                                  unreadCountSnapshot.data! ?? 0;
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: profilePictureURL != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(profilePictureURL),
                                          radius: 35,
                                        )
                                      : const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'lib/assets/images/Sky_Blue.png'),
                                          radius: 35,
                                        ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: unreadCount > 0
                                      ? CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 10,
                                          child: Text(
                                            unreadCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : null,
                                  // Eğer okunmamış mesaj yoksa trailing null olur.
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          contactName: name,
                                          contactEmail: email,
                                          currentUserEmail: currentUserEmail!,
                                          contactImageUrl: profilePictureURL,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          });
                    }
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }

  Future<DocumentSnapshot> _getInformationFuture(String email) {
    if (isCoach == false) {
      return FirebaseFirestore.instance
          .collection('Coaches')
          .doc(email)
          .collection('informations')
          .doc('information')
          .get();
    } else if (isCoach == true) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('informations')
          .doc('information')
          .get();
    } else {
      throw Exception("isCoach değeri null veya bool değil");
    }
  }

  Future<bool> userChecker(String mailAddress) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final snapshotCoaches =
          await _firestore.collection('Coaches').doc(mailAddress).get();
      if (snapshotCoaches.exists) {
        return true;
      }
      final snapshotUser =
          await _firestore.collection('Users').doc(mailAddress).get();
      if (snapshotUser.exists) {
        return false;
      }
      return false;
    } catch (e) {
      print("Error checking email in Firestore: $e");
      return false;
    }
  }

  // Okunmamış mesaj sayısını alan fonksiyon
  Future<int> _getUnreadMessageCount(
      String currentUserEmail, String contactEmail) async {
    final chatRoomId = getChatRoomId(currentUserEmail, contactEmail);
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderEmail', isEqualTo: contactEmail)
        .where('isRead', isEqualTo: false) // Okunmamış mesajları filtrele
        .get();
    return querySnapshot.size;
  }

  // Function to generate a unique chat room ID
  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "$user1-$user2";
    } else {
      return "$user2-$user1";
    }
  }
}
