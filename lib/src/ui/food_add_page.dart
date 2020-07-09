import 'package:flutter/material.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class FoodAddPage extends StatefulWidget {
  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  TextEditingController _editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('New food'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onFloatingBtnPressed,
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: showFoodAddField(),
        ));
  }

  Future<void> onFloatingBtnPressed() async {
    Navigator.pop(context);
    await FirestoreService.instance.createItemOnDb(
        User.instance.dinerId, 'foods', _editingController.text);
  }

  Widget showFoodAddField() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
          child: Text(
            'Food',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          controller: _editingController,
          decoration: InputDecoration(
            hintText: 'Food name',
          ),
        ),
      ],
    ));
  }
}
