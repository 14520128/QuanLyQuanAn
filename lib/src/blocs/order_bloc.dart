import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class OrderBloc {
  final FirestoreService _service = FirestoreService.instance;
  Stream<QuerySnapshot> _orderStream;
  String _currentDinerId;

  OrderBloc(String dinerId) {
    _currentDinerId = dinerId;
    _orderStream = _service.getItemStream('orders', dinerId);
  }

  Stream<QuerySnapshot> get orderStream => _orderStream;

  void dispose() {
    orderStream.drain();
  }
}
