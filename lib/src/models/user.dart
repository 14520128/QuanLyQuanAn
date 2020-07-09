import 'package:flutter/material.dart';

class User {
  static final User _user = new User();
  String _id;
  String _name;
  String _dinerId;
  String _role;

  static User get instance => _user;

  void setInfo(String id, String name, String dinerId, String role) {
    _id = id;
    _name = name;
    _dinerId = dinerId;
    _role = role;
    print('$id, $name, $dinerId, $role');
  }

  void deleteInfo() {
    _id = null;
    _name = null;
    _dinerId = null;
    print('Delete user info');
  }

  String get id => _id;
  String get name => _name;
  String get dinerId => _dinerId;
  String get role => _role;
  set dinerId(String value) => {_dinerId = value};
  set id(String id) => {_id = id};
  set role(String role) => {_role = role};
}
