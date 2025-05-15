import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Map<String, dynamic>> cartItems = [];
  String? mailAddress = MailService.mailValue;

  // Form için GlobalKey
  final _formKey = GlobalKey<FormState>();

  // Kart bilgileri için kontrolcü
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final userDocRef =
      FirebaseFirestore.instance.collection('Users').doc(mailAddress);
      final snapshot =
      await userDocRef.collection('shopBasket').doc('basket').get();
      if (snapshot.exists) {
        setState(() {
          cartItems = [snapshot.data() as Map<String, dynamic>];
        });
      }
    } catch (e) {
      print('Sepet öğeleri alınırken hata oluştu: $e');
    }
  }

  Future<void> _buyItems() async {
    // Formun validasyonunu kontrol et
    if (_formKey.currentState!.validate()) {
      try {
        final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(mailAddress);
        final coachesDocRef = FirebaseFirestore.instance
            .collection('Coaches')
            .doc(cartItems[0]['email']);

        final purchasedItemsDocRef =
        userDocRef.collection('purchasedItems').doc("purchased");
        final purchasedCoachesItemsDocRef =
        coachesDocRef.collection('purchasedItems').doc("purchased");

        DocumentSnapshot purchasedSnapshot = await purchasedItemsDocRef.get();
        DocumentSnapshot purchasedCoachesSnapshot =
        await purchasedCoachesItemsDocRef.get();

        Map<String, dynamic> purchasedItems = purchasedSnapshot.exists
            ? purchasedSnapshot.data() as Map<String, dynamic>
            : {};
        Map<String, dynamic> purchasedCoachesItems =
        purchasedCoachesSnapshot.exists
            ? purchasedCoachesSnapshot.data() as Map<String, dynamic>
            : {};

        for (var cartItem in cartItems) {
          String itemId =
              "${cartItem['id']}_${DateTime.now().millisecondsSinceEpoch}";
          purchasedItems[itemId] = cartItem;
          purchasedCoachesItems[itemId] = {
            ...cartItem,
            'userEmail': mailAddress, // Kullanıcının mail adresini ekledik
          };
        }

        await purchasedItemsDocRef.set(purchasedItems);
        await purchasedCoachesItemsDocRef.set(purchasedCoachesItems);
        await userDocRef.collection('shopBasket').doc('basket').delete();
        setState(() {
          cartItems = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Satın alma işlemi başarılı')),
        );
      } catch (e) {
        print('Satın alma sırasında hata oluştu: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Satın alma işleminde hata oluştu')),
        );
      }
    }
  }

  // Luhn Algoritması
  bool _luhnCheck(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return false;
    }

    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sepetim',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
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

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: cartItems.isEmpty
              ? const Center(
            child: Text(
              'Sepetinizde ürün yer almamaktadır.',
              style: TextStyle(fontSize: 20),
            ),
          )
              : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Package Name: ${cartItem['AdvertiseName']}",
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: ${cartItem['price']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Ödeme formu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Kart Numarası
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Kart Numarası',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kart numarasını girin';
                          }
                          if (!_luhnCheck(value)) {
                            return 'Geçersiz kart numarası';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),

                      // Son Kullanma Tarihi ve CVV
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryDateController,
                              decoration: InputDecoration(
                                labelText: 'SKT (AA/YY)',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Son kullanma tarihini girin';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'CVV girin';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.0),

                      // Satın Al Butonu
                      ElevatedButton(
                        onPressed: _buyItems,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 48.0),
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Satın Al'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}