class Diner {
  String _id;
  String _name;
  String _sharedId;

  String get id => _id;
  String get name => _name;
  String get sharedId => _sharedId;

  set id(String id) => {_id = id};
  set name(String value) => {_name = value};
  set sharedId(String id) => {_sharedId = id};

  Diner({String id, String name, String shareId}) {
    _id = id;
    _name = name;
    if (shareId != null) _sharedId = shareId;
  }
}
