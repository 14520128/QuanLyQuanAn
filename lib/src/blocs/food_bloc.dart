import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class FoodBloc {
  final FirestoreService _service = FirestoreService.instance;
  Stream<QuerySnapshot> _foodStream;
  String _currentDinerId;

  FoodBloc(String dinerId) {
    _currentDinerId = dinerId;
    _foodStream = _service.getItemStream('foods', dinerId);
  }

  Stream<QuerySnapshot> get foodStream => _foodStream;

  void dispose() {
    foodStream.drain();
  }
}
