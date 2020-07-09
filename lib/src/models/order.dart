import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/models/food.dart';

class Order {
  String _id;
  Map<int, Food> _orderList;
  int _table;
  Timestamp _timestamp;

  int get table => _table;
  Timestamp get timestamp => _timestamp;
}
