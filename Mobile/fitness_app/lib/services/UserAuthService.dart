import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Model/Concrete/Context.dart';

class MailService {
  static String? mailValue;
  static String? email;
  static String? name;
  static String? password;
  static String? profilePictureURL;
  static String? surname;
  static String? username;

  static Future<bool> userChecker(String mailAddress) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final snapshotUser = await _firestore.collection('Users').doc(mailAddress).get();
      if (snapshotUser.exists) {
        return false;
      }
      final snapshotCoaches = await _firestore.collection('Coaches').doc(mailAddress).get();
      if (snapshotCoaches.exists) {
        return true;
      }
      return false;
    } catch (e) {
      print("Firestore'da email kontrolünde hata: $e");
      return false;
    }
  }

  static Future<bool?> checkIfUserIsCoach() async {
    String? mailAddress = MailService.mailValue;
    if (mailAddress != null) {
      bool? isCoach = await MailService.userChecker(mailAddress);
      return isCoach;
    } else {
      print("Mail address is null");
      return null;
    }
  }

  static Future<void> loadData() async {
    String? mailAddress = MailService.mailValue;
    bool? isCoach = await checkIfUserIsCoach();
    if (mailAddress != null && isCoach != null) {
      try {
        DocumentReference informationDocRef;
        if (!isCoach) {
          informationDocRef = await DatabaseService.settingsUsersRef(mailAddress);
        } else {
          informationDocRef = await DatabaseService.settingsCoachsRef(mailAddress);
        }
        DocumentSnapshot userSnapshot = await informationDocRef.get();
        MailService.username = userSnapshot.get('username');
        MailService.name = userSnapshot.get('name');
        MailService.surname = userSnapshot.get('surname');
        MailService.email = userSnapshot.get('email');
        MailService.profilePictureURL = userSnapshot.get('profilePictureURL');
        MailService.password = userSnapshot.get('password');
        print("Username ${MailService.username} + Names: ${MailService.name} + Surname: ${MailService.surname} + E-mail: ${MailService.email} + ProfilePicture: ${MailService.profilePictureURL}");
      } catch (e) {
        print("Error fetching data: $e");
      }
    } else {
      print("Mail address or isCoach is null");
    }
  }
}