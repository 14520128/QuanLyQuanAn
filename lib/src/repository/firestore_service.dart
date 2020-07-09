import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/models/diner.dart';
import 'package:myapp/src/models/item.dart';
import 'package:myapp/src/models/user.dart';

class FirestoreService {
  static FirestoreService _fireComm = new FirestoreService();
  static FirestoreService get instance => _fireComm;

  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getItemStream(String item, String dinerId) {
    return _firestore
        .collection('diners')
        .document(dinerId)
        .collection(item)
        .snapshots();
  }

  Stream<DocumentSnapshot> getDatabyUserId(String userId) {
    return _firestore.collection('users').document(userId).snapshots();
  }

  Stream<DocumentSnapshot> getDinerStream(String dinerId) {
    return _firestore.collection('diners').document(dinerId).snapshots();
  }

  Future<void> createDinerOnDb(String name) async {
    CollectionReference reference = _firestore.collection('diners');
    DocumentReference newDiner = await reference.add({'name': name});
    User.instance.dinerId = newDiner.documentID;
    DocumentReference currentUser =
        _firestore.collection('users').document(User.instance.id);
    await currentUser
        .setData({'diner': newDiner.documentID, 'role': 'owner'}, merge: true);
    User.instance.role = 'owner';
  }

  Future<String> joinDiner(String sharedId, Diner diner) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('sharedID').document(sharedId).get();
    if (snapshot.exists) {
      print(sharedId.toString());
      diner.sharedId = sharedId;
      print(diner.sharedId);
      String dinerId = snapshot.data['diner'];
      await saveDataOnDb(
          'users', User.instance.id, {'diner': dinerId, 'role': 'employee'});
      return dinerId;
    } else
      return Future.error('Wrong sharedId: $sharedId');
  }

  Future<void> createItemOnDb(String dinerId, String item, String name) async {
    await _firestore
        .collection('diners')
        .document(dinerId)
        .collection(item)
        .add({'name': name, 'queue': 0});
  }

  Future<void> saveSharedIdOnDb(String sharedId, String dinerId) async {
    DocumentSnapshot document =
        await _firestore.collection('sharedID').document(sharedId).get();

    if (document.exists) {
      return Future.error('Duplicated shareID! Please type another ID');
    } else {
      await saveDataOnDb('sharedID', sharedId, {'diner': dinerId});
      await saveDataOnDb('diners', dinerId, {'sharedID': sharedId});
    }
  }

  Future<void> saveDataOnDb(
      String collection, String document, Map<String, String> data) async {
    await _firestore
        .collection(collection)
        .document(document)
        .setData(data, merge: true);
  }

  Future<void> saveUserOnDb(String userId) async {
    await saveDataOnDb('users', userId, {'name': 'no name', 'role': 'free'});
    User.instance.setInfo(userId, 'no name', null, 'free');
  }

  Future<void> getUserInfo(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').document(userId).get();
    Map<String, dynamic> userInfo = snapshot.data;
    User.instance
        .setInfo(userId, userInfo['name'], userInfo['diner'], userInfo['role']);
  }

  Future<String> getDinerName(String dinerId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('diners').document(dinerId).get();
    String dinerName = snapshot.data['name'];
    return dinerName;
  }

  Future createOrderOnDb(String dinerId, List<int> foodCount,
      List<int> drinkCount, int table) async {
    Map<String, int> drinks = new Map();
    int count;
    for (int i = 0; i < drinkCount.length; i++) {
      count = drinkCount.elementAt(i);
      if (count > 0) {
        drinks.addAll({Drinks.instance.map.keys.elementAt(i): count});
      }
    }

    Map<String, int> foods = new Map();
    for (int i = 0; i < foodCount.length; i++) {
      count = foodCount.elementAt(i);
      if (count > 0) {
        foods.addAll({Foods.instance.map.keys.elementAt(i): count});
      }
    }

    Map<String, dynamic> data = new Map();
    data.addAll({
      'time': Timestamp.now(),
      'drinks': drinks,
      'foods': foods,
      'table': table
    });
    await _firestore.collection('/diners/${dinerId}/orders').add(data);
  }
}
