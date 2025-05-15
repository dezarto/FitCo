import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/Views/ShoppingCartView/shopping_cart.dart';

class SelecetMembershipPage extends StatelessWidget {
  final String coachEmail; // Coach emailini alacak değişken
  const SelecetMembershipPage({Key? key, required this.coachEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Membership Type',
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
        backgroundColor: Colors.transparent, // backgroundColor transparan yapılmalı
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartPage()),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<QuerySnapshot>(
        // Coach'un paketlerini sorgula
        future: FirebaseFirestore.instance
            .collection('Coaches')
            .doc(coachEmail)
            .collection('packages')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Paketleri listele
          final packages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final packageData =
              packages[index].data() as Map<String, dynamic>;
              final packageName = packages[index].id;
              final packageAdvertiseName =
                  packageData['AdvertiseName'] ?? '';
              final packageDescription = packageData['Description'] ?? '';
              final packageSlogan = packageData['Slogan'] ?? '';
              final packagePrice = packageData['priceController'] ?? '';
              final packageId = packageData['id'] ?? '';
              final email = packageData['email'] ?? '';
              final imageURL = packageData['imageURL'] ?? '';
              // Diğer paket bilgilerini packageData'dan al
              return MembershipCard(
                title: packageName,
                advertiseName: packageAdvertiseName,
                description: packageDescription,
                slogan: packageSlogan,
                price: packagePrice,
                id: packageId,
                email: email,
                imageURL: imageURL,
                onPressed: () async {
                  final cartItem = {
                    'id': packageId,
                    'AdvertiseName': packageAdvertiseName,
                    'price': packagePrice,
                    'email': email,
                    'imageURL': imageURL,
                  };
                  try {
                    String? mailAddress = MailService.mailValue;
                    if (mailAddress != null) {
                      DocumentReference basketRef =
                      await DatabaseService.shopRef(mailAddress);
                      // Veriyi ekle
                      await basketRef.set(cartItem);
                      print('Veri başarıyla eklendi.');
                    } else {
                      print('E-posta adresi bulunamadı.');
                    }
                  } catch (e) {
                    print('Hata oluştu: $e');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingCartPage()),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}

class MembershipCard extends StatelessWidget {
  final String title;
  final String advertiseName;
  final String description;
  final String slogan;
  final String price;
  final String id;
  final String email;
  final String imageURL;
  final VoidCallback onPressed;
  const MembershipCard({
    Key? key,
    required this.title,
    required this.advertiseName,
    required this.description,
    required this.slogan,
    required this.price,
    required this.onPressed,
    required this.id,
    required this.email,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageURL,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advertiseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Açıklama:', description),
                  const SizedBox(height: 8),
                  _buildInfoRow('Slogan:', slogan),
                  const SizedBox(height: 8),
                  _buildInfoRow('Fiyat:', price),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Add'),
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

  Widget _buildInfoRow(String label, String value) {
    return Wrap(
      children: [
        Text(
          '$label ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}