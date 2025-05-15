import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool? isCoach;
  File? _image;
  String? _uploadedFileURL;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsCoach();
  }

  Future<void> _checkIfUserIsCoach() async {
    isCoach = await MailService.checkIfUserIsCoach(); //  Await the result
    if (isCoach != null) {
      await MailService.loadData();
      setState(() {
        nameController.text = MailService.name ?? '';
        surnameController.text = MailService.surname ?? '';
        usernameController.text = MailService.username ?? '';
        passwordController.text = MailService.password ?? '';
        emailController.text = MailService.email ?? '';
        _uploadedFileURL = MailService.profilePictureURL ?? '';
      });
    } else {
      print("Error determining user type: SettingPage.dart");
    }
    setState(() {});
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
        .child('profilePictures/${DateTime.now().millisecondsSinceEpoch}');
    final firebase_storage.UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask;
    _uploadedFileURL = await storageRef.getDownloadURL();
    setState(() {});
  }

  Future<void> _updateProfilePictureURL() async {
    if (MailService.mailValue != null && isCoach != null) {
      DocumentReference settingsDocRef;
      if (!isCoach!) {
        settingsDocRef =
        await DatabaseService.settingsUsersRef(MailService.mailValue!);
      } else {
        settingsDocRef =
        await DatabaseService.settingsCoachsRef(MailService.mailValue!);
      }
      await settingsDocRef.update({'profilePictureURL': _uploadedFileURL});
    }
  }

  void updateUserFirestore() async {
    if (MailService.mailValue != null) {
      final settingsDocRef =
      await DatabaseService.settingsUsersRef(MailService.mailValue!);
      await settingsDocRef.update({
        'name': nameController.text,
        'surname': surnameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'profilePictureURL': _uploadedFileURL,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Veri güncellendi')));
    } else {
      print("Mail address is null: MeasurementsInsidePage.dart");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Mail address is missing!')));
    }
  }

  void updateCoachFirestore() async {
    if (MailService.mailValue != null) {
      final settingsDocRef =
      await DatabaseService.settingsCoachsRef(MailService.mailValue!);
      await settingsDocRef.update({
        'name': nameController.text,
        'surname': surnameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'profilePictureURL': _uploadedFileURL,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Veri güncellendi')));
    } else {
      print("Mail address is null: MeasurementsInsidePage.dart");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Mail address is missing!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCoach != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: BackButton(),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display uploaded image or default avatar
                  _uploadedFileURL != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(_uploadedFileURL!),
                    radius: 50,
                  )
                      : const CircleAvatar(
                    backgroundImage:
                    AssetImage('lib/assets/images/Sky_Blue.png'),
                    radius: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Düğmeleri yatayda ortala
                    children: [
                      ElevatedButton(
                        onPressed: chooseFile,
                        child: const Text('Choose File'),
                      ),
                      SizedBox(width: 10), // Düğmeler arasına boşluk ekle
                      ElevatedButton(
                        onPressed: () {
                          uploadFile().then((_) => _updateProfilePictureURL());
                        },
                        child: const Text('Upload File'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Name'),
                      subtitle: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Surname'),
                      subtitle: TextField(
                        controller: surnameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your surname',
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Username'),
                      subtitle: TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your username',
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Password'),
                      subtitle: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('Email'),
                      subtitle: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      if (!isCoach!) {
                        updateUserFirestore();
                      } else {
                        updateCoachFirestore();
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarComponent(),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}