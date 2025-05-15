import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/CoachView/advertiseAdd.dart';
import 'package:fitness_app/Views/components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/Views/CoachView/EditAdvertise.dart';
import 'package:fitness_app/Views/CoachView/MyAdvertisements.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class AdvertisePage extends StatefulWidget {
  const AdvertisePage({super.key});

  @override
  _AdvertisePageState createState() => _AdvertisePageState();
}

class _AdvertisePageState extends State<AdvertisePage> {
  String? mailAddress = MailService.mailValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'İlan Ver',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
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
        backgroundColor: Colors.transparent,
      ),

      body: FutureBuilder<CollectionReference>(
        future: DatabaseService.packageRef(mailAddress!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          CollectionReference packagesCollection = snapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream: packagesCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  // AdvertiseName değerini alıyoruz
                                  documents[index].get('AdvertiseName'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditAdvertise(
                                                packageName:
                                                documents[index].id),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Kitap iconu
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyAdvertisements(
                                                    packageName:
                                                    documents[index].id),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.book,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Silgi iconu
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          await packagesCollection
                                              .doc(documents[index].id)
                                              .delete();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('İlan silindi')),
                                          );
                                        } catch (e) {
                                          print("Error deleting document: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'İlan silinirken hata oluştu')),
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: documents.length,
                    ),
                  ),
                ],
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
              builder: (context) => AdvertiseAdd(),
            ),
          );
        }, // addNewAd,
        child: Icon(Icons.add),
        backgroundColor: Colors.red, // Buton rengi
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Sağ alt köşe
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}