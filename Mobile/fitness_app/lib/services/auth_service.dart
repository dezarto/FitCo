import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Views/CoachView/advertisePage.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Views/HomeView/HomePage.dart';
import 'package:fitness_app/Views/LoginView/loginPage.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final coachCollection = FirebaseFirestore.instance.collection("Coaches");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerUser({required String name, required String email, required String password, required String surname, required String username}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Kullanıcı başarıyla kaydedildiğinde buraya gelecektir
      // Başka işlemler de burada yapılabilir
      print("Kullanıcı kaydedildi: ${userCredential.user!.uid}");
    } catch (e) {
      // Kayıt işlemi başarısız olduğunda buraya gelecektir
      print("Hata oluştu: $e");
      // Hata durumunda kullanıcıya uygun geri bildirim gösterilebilir
    }
  }

  Future<void> signUp({required BuildContext context, required String name, required String email, required String password, required String surname, required String username, required bool userType}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userType) {
          // Coach ise
          await _registerCoach(name: name, email: email, password: password, surname: surname, username: username, userType: userType);
        } else {
          // User ise
          await _registerUser(name: name, email: email, password: password, surname: surname, username: username, userType: userType);
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } on FirebaseAuthException catch (e) {
      //Buraya gerekli hata yakalam eklenebilir
    }
  }

  Future<void> signIn(BuildContext context, {required String email, required String password}) async {
    final navigator = Navigator.of(context);

    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Check if the user is a coach
        final coachDoc = await coachCollection.doc(email).get();
        if (coachDoc.exists) {
          // User is a coach, navigate to AdvertisePage
          navigator.pushReplacement(MaterialPageRoute(builder: (context) => AdvertisePage()));
        } else {
          // User is not a coach, check if it's a regular user
          final userDoc = await userCollection.doc(email).get();
          if (userDoc.exists) {
            // User is a regular user, navigate to HomePage
            navigator.pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            // Handle the case where the user is not found in either collection
            print("Error: User not found in either collection.");
            // You might want to show an error message to the user here.
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors here
      print("Error signing in: $e");
      // You might want to show an error message to the user here.
    }
  }

  Future<void> _registerUser({required String name, required String email, required String password, required String surname, required String username, required bool userType}) async {
    await userCollection.doc(email).set({
      "email" : email,
      "name": name,
      "password": password,
      "surname": surname,
      "username": username,
      "userType": userType,
      "profilePictureURL": ""
    });

    await userCollection.doc(email).collection("informations").doc("information").set({
      "email" : email,
      "name": name,
      "password": password,
      "surname": surname,
      "username": username,
      "profilePictureURL": ""
    });
    await userCollection.doc(email).collection("packages").doc("Diet").set({
      "added": "-",
    });
    await userCollection.doc(email).collection("packages").doc("Measurements").set({
      "added": "-",
    });
    await userCollection.doc(email).collection("packages").doc("Training").set({
      "added": "-",
    });
  }

  Future<void> _registerCoach({required String name, required String email, required String password, required String surname, required String username, required bool userType}) async {
    await coachCollection.doc(email).set({
      "email": email,
      "name": name,
      "password": password,
      "surname": surname,
      "username": username,
      "userType": userType,
      "profilePictureURL": ""
    });
    await coachCollection.doc(email).collection("informations").doc("information").set({
      "email": email,
      "name": name,
      "password": password,
      "surname": surname,
      "username": username,
      "profilePictureURL": ""
    });
  }
}
