import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/CoachView/advertisePage.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class AdvertiseAdd extends StatefulWidget {
  const AdvertiseAdd({super.key});

  @override
  _AdvertiseAddState createState() => _AdvertiseAddState();
}

class _AdvertiseAddState extends State<AdvertiseAdd> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sloganController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _advertiseNameController = TextEditingController();
  File? _image;
  String? _uploadedFileURL;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.red,
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
                  controller: _advertiseNameController,
                  onChanged: (value) {
                    bool hasNonLetterCharacters =
                    value.contains(RegExp(r'[^a-zA-Z]'));
                    if (hasNonLetterCharacters) {
                      _advertiseNameController.text =
                          value.substring(0, value.length - 1);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen İlan ismi Girin';
                    }
                    return null;
                  },
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
                const Text(
                  ' Kapak Fotoğrafı yükleyin:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                // Display uploaded image or default placeholder
                _uploadedFileURL != null
                    ? Image.network(_uploadedFileURL!)
                    : const SizedBox(
                  width: 100,
                  height: 100,
                  child: Placeholder(),
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
                      saveDataToFirestore(_advertiseNameController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvertisePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Arka plan rengi
                    ),
                    child: const Text(
                      'İlan ver',
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
    String advertiseNameController = _advertiseNameController.text;
    // UUID kütüphanesi ile benzersiz bir ID oluşturuyoruz
    var uuid = Uuid();
    String uniqueId = uuid.v4();
    if (mailAddress != null) {
      final packetAdverDocRef = await DatabaseService.packageRef(mailAddress);
      DocumentReference addPacketAdverDocRef =
      packetAdverDocRef.doc(uniqueId); // Benzersiz ID'yi kullanıyoruz
      addPacketAdverDocRef.set({
        "Description": descriptionController,
        "Slogan": sloganController,
        "priceController": priceController,
        "AdvertiseName": advertiseNameController,
        "id": uniqueId, // ID'yi Firestore'a kaydediyoruz
        "imageURL": _uploadedFileURL, // Resim URL'sini ekle
        "email": mailAddress,
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
    _advertiseNameController.dispose();
    super.dispose();
  }
}