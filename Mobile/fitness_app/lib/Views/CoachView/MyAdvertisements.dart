import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class MyAdvertisements extends StatefulWidget {
  final String packageName;
  const MyAdvertisements({super.key, required this.packageName});

  @override
  _MyAdvertisementsState createState() => _MyAdvertisementsState();
}

class _MyAdvertisementsState extends State<MyAdvertisements> {
  late Stream<DocumentSnapshot> _advertisementStream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      final packageDocRef = await DatabaseService.packageRef(mailAddress);
      setState(() {
        _advertisementStream = packageDocRef.doc(widget.packageName).snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'İlanlarım',
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'İlan Başlığı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildAdvertiseName(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Slogan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),


            _buildSlogan(),
            const SizedBox(height: 20),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Açıklama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),


            _buildDescription(),
            const SizedBox(height: 20),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Fiyat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            _buildPrice(),
            const SizedBox(height: 20),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Kapak Fotoğrafı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),


          ],
        ),
      ),
    );
  }

  Widget _buildAdvertiseName() {
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                snapshot.data?['AdvertiseName'] ?? 'İlan Başlığı Bulunamadı',
                style: TextStyle(fontSize: 16)),
          );
        } else {
          return Text('Veri yok');
        }
      },
    );
  }

  Widget _buildSlogan() {
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Veri yüklendikten sonra
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              snapshot.data?['Slogan'] ?? 'Slogan Bulunamadı',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return Text('Veri yok');
        }
      },
    );
  }

  Widget _buildDescription() {
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
              CircularProgressIndicator()); // Veri yüklenirken bir progress göster
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              snapshot.data!['Description'] ?? 'Açıklama Bulunamadı',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return Text('Veri yok'); // Veri yoksa bir mesaj göster
        }
      },
    );
  }

  Widget _buildPrice() {
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
              CircularProgressIndicator()); // Veri yüklenirken bir progress göster
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              snapshot.data!['priceController'] != null
                  ? '${snapshot.data!['priceController']} TL'
                  : '',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return Text('Veri yok'); // Veri yoksa bir mesaj göster
        }
      },
    );
  }

  // Fotoğrafı gösteren widget
  Widget _buildImage() {
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!['imageURL'] != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Image.network(
              snapshot.data!['imageURL'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return SizedBox.shrink(); // Fotoğraf yoksa hiçbir şey gösterme
        }
      },
    );
  }
}