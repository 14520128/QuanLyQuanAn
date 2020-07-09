import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class DrinkBloc {
  final FirestoreService _service = FirestoreService.instance;
  Stream<QuerySnapshot> _drinkStream;
  String _currentDinerId;

  DrinkBloc(String dinerId) {
    _currentDinerId = dinerId;
    _drinkStream = _service.getItemStream('drinks', dinerId);
  }

  Stream<QuerySnapshot> get drinkStream => _drinkStream;

  void dispose() {
    drinkStream.drain();
  }
}
