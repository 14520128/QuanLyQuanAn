import 'package:flutter/material.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/repository/firestore_service.dart';

class DrinkAddPage extends StatefulWidget {
  @override
  _DrinkAddPageState createState() => _DrinkAddPageState();
}

class _DrinkAddPageState extends State<DrinkAddPage> {
  TextEditingController _editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('New drink'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onFloatingBtnPressed,
          icon: Icon(Icons.save),
          label: Text('Save'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: showDrinkAddField(),
        ));
  }

  Future<void> onFloatingBtnPressed() async {
    Navigator.pop(context);
    await FirestoreService.instance.createItemOnDb(
        User.instance.dinerId, 'drinks', _editingController.text);
  }

  Widget showDrinkAddField() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
          child: Text(
            'Drink',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          controller: _editingController,
          decoration: InputDecoration(
            hintText: 'Drink name',
          ),
        ),
      ],
    ));
  }
}
