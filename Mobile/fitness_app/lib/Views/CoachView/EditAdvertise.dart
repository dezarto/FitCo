import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditAdvertise extends StatefulWidget {
  final String packageName;

  const EditAdvertise({super.key, required this.packageName});

  @override
  _EditAdvertise createState() => _EditAdvertise();
}

class _EditAdvertise extends State<EditAdvertise> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sloganController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _AdvertiseNameController = TextEditingController();
  File? _image;
  String? _uploadedFileURL;
  String? _existingImageURL; // Mevcut fotoğrafın URL'sini tutacak değişken

  @override
  void initState() {
    super.initState();
    fetchAdvertiseName();
  }

  Future chooseFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_image == null) return;
    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('advertisePictures/${DateTime.now().millisecondsSinceEpoch}');
    final firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask;
    _uploadedFileURL = await storageRef.getDownloadURL();
    setState(() {});
  }

  void fetchAdvertiseName() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      try {
        final coachesDocRef = await DatabaseService.packageRef(mailAddress);
        DocumentSnapshot documentSnapshot = await coachesDocRef
            .doc(widget.packageName)
            .get(); // widget.packageName kullanarak erişim
        if (documentSnapshot.exists &&
            documentSnapshot['AdvertiseName'] != null) {
          _AdvertiseNameController.text = documentSnapshot[
              'AdvertiseName']; // documentSnapshot['AdvertiseName'] değerini kullanarak atama
          _sloganController.text = documentSnapshot['Slogan'];
          _descriptionController.text = documentSnapshot['Description'];
          _priceController.text = documentSnapshot['priceController'];
          _existingImageURL =
              documentSnapshot['imageURL']; // Mevcut fotoğraf URL'sini al
        }
      } catch (e) {
        print("Error fetching AdvertiseName: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'İlan Bilgileri',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'İlan Başlığı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _AdvertiseNameController,
                  onChanged: (value) {},
                  validator: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'İlanınız için bir başlık girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Slogan:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sloganController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir slogan girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'İlanınız için bir slogan girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Açıklama:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir açıklama girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'İlanınızın açıklamasını girin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fiyat:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir fiyat girin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Fiyatı belirleyin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  ' Kapak Fotoğrafı:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                    image: _existingImageURL != null // Null kontrolü eklendi
                        ? DecorationImage(
                      image: NetworkImage(_existingImageURL!), // '!' ile null olmadığını belirtiyoruz
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: chooseFile,
                      child: const Text('Choose Image'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        uploadFile();
                      },
                      child: const Text('Upload Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      saveDataToFirestore(widget.packageName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Arka plan rengi
                    ),
                    child: const Text(
                      'İlanı Güncelle',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }

  saveDataToFirestore(String packageName) async {
    String? mailAddress = MailService.mailValue;
    String sloganController = _sloganController.text;
    String descriptionController = _descriptionController.text;
    String priceController = _priceController.text;
    String AdvertiseNameController = _AdvertiseNameController.text;
    if (mailAddress != null) {
      final packetAdverDocRef = await DatabaseService.packageRef(mailAddress);
      DocumentReference addPacketAdverDocRef =
          packetAdverDocRef.doc(packageName);

      addPacketAdverDocRef.update({
        "Description": descriptionController,
        "Slogan": sloganController,
        "priceController": priceController,
        "AdvertiseName": AdvertiseNameController,
        "imageURL":
            _uploadedFileURL != null ? _uploadedFileURL : _existingImageURL,
      }).then((value) {
        print("Data saved.");
      }).catchError((error) {
        print("Something went wrong!: $error");
      });
    } else {
      print("Mail adresi tanımsız hata: advertiseInformation.dart");
    }
  }

  @override
  void dispose() {
    _sloganController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _AdvertiseNameController.dispose();
    super.dispose();
  }
}
