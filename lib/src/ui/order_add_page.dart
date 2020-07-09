import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/src/models/item.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class OrderAddPage extends StatefulWidget {
  @override
  _OrderAddPageState createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {
  Foods _foods = Foods.instance;
  Drinks _drinks = Drinks.instance;
  List<int> foodCount = List.filled(Foods.instance.length, 0);
  List<int> drinkCount = List.filled(Drinks.instance.length, 0);
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Order'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          onPressed: onFloatingBtnPressed,
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 0, 8.0),
                  child: Text(
                    'Food',
                    style: TextStyle(fontSize: 16.0),
                  )),
              showListFood(),
              Container(
                  padding: EdgeInsets.fromLTRB(16.0, 24.0, 0, 8.0),
                  child: Text(
                    'Drink',
                    style: TextStyle(fontSize: 16.0),
                  )),
              showListDrink(),
              showTableInput(),
            ],
          ),
        ));
  }

  void onFloatingBtnPressed() {
    FirestoreService.instance.createOrderOnDb(User.instance.dinerId, foodCount,
        drinkCount, int.tryParse(controller.text));
    Navigator.of(context).pop();
  }

  Widget showListFood() {
    return Container(
      height: 192.0,
      child: ListView.builder(
          itemCount: _foods.length,
          itemBuilder: (context, index) {
            return Card(
              color: index.isEven ? Colors.green[300] : Colors.lightGreen[300],
              child: ListTile(
                leading: Container(
                  width: 36.0,
                  height: 36.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Text(
                    '${foodCount.elementAt(index)}',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                title: Text(
                  _foods.map.values.elementAt(index),
                ),
                trailing: Container(
                  width: 72.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 30.0,
                        child: IconButton(
                            iconSize: 24.0,
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () {
                              setState(() {
                                if (foodCount[index] > 0) foodCount[index]--;
                              });
                            }),
                      ),
                      SizedBox(
                        width: 30.0,
                        child: IconButton(
                            iconSize: 24.0,
                            icon: Icon(
                              Icons.arrow_upward,
                            ),
                            onPressed: () {
                              setState(() {
                                foodCount[index]++;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget showListDrink() {
    return Container(
      height: 192.0,
      child: ListView.builder(
          itemCount: _drinks.length,
          itemBuilder: (context, index) {
            return Card(
              color: index.isEven ? Colors.blue[200] : Colors.blue[50],
              child: ListTile(
                leading: Container(
                  width: 36.0,
                  height: 36.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.brown),
                  child: Text(
                    '${drinkCount.elementAt(index)}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(_drinks.map.values.elementAt(index)),
                trailing: Container(
                  width: 72.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 30.0,
                        child: IconButton(
                            iconSize: 24.0,
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () {
                              setState(() {
                                if (drinkCount[index] > 0) drinkCount[index]--;
                              });
                            }),
                      ),
                      SizedBox(
                        width: 30.0,
                        child: IconButton(
                            iconSize: 24.0,
                            icon: Icon(Icons.arrow_upward),
                            onPressed: () {
                              setState(() {
                                drinkCount[index]++;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget showTableInput() {
    return Container(
      width: 90.0,
      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      child: TextField(
        controller: controller,
        autofocus: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(Icons.restaurant),
            hintText: 'Table',
            fillColor: Colors.deepOrange),
      ),
    );
  }
}
