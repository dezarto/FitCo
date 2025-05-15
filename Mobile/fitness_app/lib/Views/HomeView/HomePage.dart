import 'package:fitness_app/Views/PackagesView/packages_for_user.dart';
import 'package:fitness_app/Views/ShoppingCartView/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: const SpacedItemsList(),
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }
}

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Coaches').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final coaches = snapshot.data!.docs;
        return ListView.builder(
          itemCount: coaches.length,
          itemBuilder: (context, index) {
            final coach = coaches[index];
            final email = coach.id;
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Coaches')
                  .doc(email)
                  .collection('informations')
                  .doc('information')
                  .get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot> informationSnapshot) {
                if (informationSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (informationSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${informationSnapshot.error}'),
                  );
                }
                final name = informationSnapshot.data!['name'];
                final profilePictureURL =
                informationSnapshot.data!['profilePictureURL'];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelecetMembershipPage(
                          coachEmail: email,
                        ),
                      ),
                    );
                    print("Card tıklandı: $name - $email");
                  },
                  child: ItemWidget(
                    title: name,
                    imageUrl: profilePictureURL,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Coach',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}