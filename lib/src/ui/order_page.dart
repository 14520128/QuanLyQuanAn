import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/order_bloc.dart';
import 'package:myapp/src/models/item.dart';
import 'package:myapp/src/models/order.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/ui/food_page.dart';
import 'package:myapp/src/ui/order_add_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderBloc _bloc = new OrderBloc(User.instance.dinerId);

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
          icon: Icon(Icons.add),
          label: Text('New order'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: showListOrder(),
        ));
  }

  void onFloatingBtnPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderAddPage()));
  }

  Widget showListOrder() {
    Map mapDrink = new Map();
    Map mapFood = new Map();
    Timestamp timestamp;
    return StreamBuilder(
        stream: _bloc.orderStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();
          List<DocumentSnapshot> list = snapshot.data.documents;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                mapDrink.clear();
                mapFood.clear();
                mapDrink.addAll(list.elementAt(index).data['drinks']);
                mapFood.addAll(list.elementAt(index).data['foods']);
                timestamp = list.elementAt(index).data['time'];
                return Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? Colors.amber[300]
                          : Colors.amberAccent[100],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Table ${list.elementAt(index).data['table'].toString()}',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                                Text('${timestamp.toDate().toString()}'),
                              ]),
                        ),
                        Container(
                          height:
                              mapFood.length < 4 ? mapFood.length * 20.0 : 80.0,
                          child: ListView.builder(
                              itemCount: mapFood.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  '${Foods.instance.map[mapFood.keys.elementAt(index)]} : ${mapFood.values.elementAt(index)}',
                                  style: TextStyle(fontSize: 16.0),
                                );
                              }),
                        ),
                        Container(
                          height: mapDrink.length < 3
                              ? mapDrink.length * 20.0
                              : 60.0,
                          child: ListView.builder(
                              itemCount: mapDrink.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  '${Drinks.instance.map[mapDrink.keys.elementAt(index)]} : ${mapDrink.values.elementAt(index)}',
                                  style: TextStyle(fontSize: 16.0),
                                );
                              }),
                        ),
                      ],
                    ));
              });
        });
  }
}
