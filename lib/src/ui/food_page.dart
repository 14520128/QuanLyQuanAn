import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/food_bloc.dart';
import 'package:myapp/src/models/item.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/ui/drink_page.dart';
import 'package:myapp/src/ui/food_add_page.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  FoodBloc _bloc = new FoodBloc(User.instance.dinerId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Food'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          onPressed: onFloatingBtnPressed,
          icon: Icon(Icons.add),
          label: Text('New food'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: showListFood(),
        ));
  }

  void onFloatingBtnPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FoodAddPage()));
  }

  Widget showListFood() {
    List<DocumentSnapshot> list;
    DocumentSnapshot documentSnapshot;
    return StreamBuilder(
        stream: _bloc.foodStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();
          list = snapshot.data.documents;
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                documentSnapshot = list.elementAt(index);
                Foods.instance.addPair(
                    documentSnapshot.documentID, documentSnapshot.data['name']);
                return Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color:
                          index.isEven ? Colors.green : Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          list.elementAt(index).data['name'].toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  index.isEven ? Colors.white : Colors.black),
                        ),
                        Text(
                          list.elementAt(index).data['queue'].toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  index.isEven ? Colors.white : Colors.black),
                        )
                      ],
                    ));
              });
        });
  }
}
