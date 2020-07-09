class Food {
  String _id;
  String _name;
  String _unit;

  Food(String id, String name, {String unit}) {
    _id = id;
    _name = name;
    _unit = unit;
  }

  String get id => _id;
  String get name => _name;
  String get unit => _unit;
}

class FoodList {
  final List<Food> _list = new List();

  void addFood(Food food) {
    _list.add(food);
  }

  bool isContain(Food food) {
    return _list.contains(food);
  }
}
