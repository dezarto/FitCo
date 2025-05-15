import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Firestore instance
  static final _firestore = FirebaseFirestore.instance;

  /// User Reference
  static final CollectionReference _usersRef = _firestore.collection('Users');
  static DocumentReference _specificUserRef(String email) =>
      _usersRef.doc(email);

  /// Coaches Reference
  static final CollectionReference _coachesRef = _firestore.collection('Coaches');
  static DocumentReference _specificCoachesRef(String email) =>
      _coachesRef.doc(email);

  /// Basket Reference
  static Future<DocumentReference> shopRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("shopBasket").doc("basket");
  }

  /// purchased Reference
  static Future<DocumentReference> purchasedRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("purchased").doc("purchased1");
  }

  /// User Measurements Reference
  static Future<CollectionReference> measurementsRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("packages").doc("Measurements").collection("Dates");
  }
  /// User Training Reference
  static Future<CollectionReference> trainingRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("packages").doc("Training").collection("Programs");
  }
  /// User Diet Reference
  static Future<DocumentReference> dietRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("packages").doc("Diet");
  }
  /// User Settings reference
  static Future<DocumentReference> settingsUsersRef(String email) async {
    final userDoc = await _specificUserRef(email).get();
    return userDoc.reference.collection("informations").doc("information");
    }


  /// Coach Package Reference
  static Future<CollectionReference> packageRef(String email) async {
    final userDoc = await _specificCoachesRef(email).get();
    return userDoc.reference.collection("packages");
  }
  /// Coach Student Reference
  static Future<CollectionReference> studentRef(String email) async {
    final userDoc = await _specificCoachesRef(email).get();
    return userDoc.reference.collection("Students");
  }
  /// Coach Personal Information Reference
  static Future<CollectionReference> personalInfoRef(String email) async {
    final userDoc = await _specificCoachesRef(email).get();
    return userDoc.reference.collection("PersonalInfo");
  }
  /// Coach Settings reference
  static Future<DocumentReference> settingsCoachsRef(String email) async {
    final userDoc = await _specificCoachesRef(email).get();
    return userDoc.reference.collection("informations").doc("information");
  }

  static Future<DocumentReference> DietCoachsRef(String email) async {
    final userDoc = await _specificCoachesRef(email).get();
    return userDoc.reference.collection("diets").doc("diet");
  }
}

/* kullanım örneği
*
* final measurementsDocRef = await DatabaseService.trainingRef(mailAddress);
*
* String? mailAddress = MailService.mailValue;
*/