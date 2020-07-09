class Drinks {
  static final Drinks _drinks = new Drinks();
  static Drinks get instance => _drinks;

  final Map<String, String> _map = new Map();

  int get length => _map.length;

  String getValueAt(int index) => _map.values.elementAt(index);

  void addPair(String id, String name) {
    _map.addAll({id: name});
  }

  Map<String, String> get map => _map;
}

class Foods {
  static final Foods _foods = new Foods();
  static Foods get instance => _foods;

  final Map<String, String> _map = new Map();

  int get length => _map.length;

  String getValueAt(int index) => _map.values.elementAt(index);

  void addPair(String id, String name) {
    _map.addAll({id: name});
  }

  Map<String, String> get map => _map;
}
