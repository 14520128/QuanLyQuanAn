import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/diner.dart';
import 'package:myapp/src/models/user.dart';
import 'package:myapp/src/repository/firebase_auth.dart';
import 'package:myapp/src/repository/firestore_service.dart';
import 'package:myapp/src/ui/drink_page.dart';
import 'package:myapp/src/ui/food_page.dart';
import 'package:myapp/src/ui/order_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.user, this.logoutCallback})
      : super(key: key);

  final FireAuth auth;
  final VoidCallback logoutCallback;
  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _fireService = FirestoreService.instance;
  Diner _diner = new Diner();
  bool _isCreateState = true;
  final TextEditingController _editingController = new TextEditingController();
  String sharedIdValidResult = 'Create sharedID and let people join';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Home page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Log out',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: signOut,
          )
        ],
      ),
      body: Container(
        child: showDinerManagePage(),
      ),
    );
  }

  Widget showDinerManagePage() {
    return StreamBuilder(
      stream: _fireService.getDatabyUserId(User.instance.id),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.data.containsKey('diner')) {
            String dinerId = snapshot.data.data['diner'];
            User.instance.dinerId = dinerId;
            User.instance.role = snapshot.data.data['role'];
            return showDiner();
          }
          return showCreateDinerPage();
        }
        return Text('No data');
      },
    );
  }

  Widget showCreateDinerPage() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _editingController,
            decoration: InputDecoration(
                hintText: _isCreateState
                    ? 'Type Diner name to create'
                    : 'Type Diner Owner email to join'),
          ),
          RaisedButton(
            onPressed: onPrimaryBtnPressed,
            child: Text(_isCreateState ? 'Create' : 'Join'),
          ),
          FlatButton(
            onPressed: onSecondaryBtnPressed,
            highlightColor: Colors.white,
            child: Text(_isCreateState ? 'Join' : 'Create'),
          ),
        ],
      ),
    );
  }

  void onPrimaryBtnPressed() {
    if (_isCreateState) {
      _fireService.createDinerOnDb(_editingController.text);
    } else {
      _fireService.joinDiner(_editingController.text, _diner);
    }
  }

  void onSecondaryBtnPressed() {
    setState(() {
      _isCreateState = !_isCreateState;
    });
  }

  Widget showDiner() {
    print(User.instance.dinerId);
    return StreamBuilder(
        stream: _fireService.getDinerStream(User.instance.dinerId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map dinerInfo = snapshot.data.data;
            _diner = new Diner(
                id: User.instance.dinerId,
                name: dinerInfo['name'],
                shareId: dinerInfo['sharedID']);
            return SingleChildScrollView(
              child: Container(
                height: 540.0,
                padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.deepOrange),
                      child: Text(
                        _diner.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(children: <Widget>[
                      SizedBox(
                        height: 128.0,
                        width: 128.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.amber,
                          onPressed: onOrdersBtnPressed,
                          child: Text(
                            'Orders',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 128.0,
                            width: 128.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              color: Colors.green,
                              onPressed: onFoodsBtnPressed,
                              child: Text(
                                'Foods',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 128.0,
                            width: 128.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              color: Colors.blue,
                              onPressed: onDrinksBtnPressed,
                              child: Text(
                                'Drinks',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                    showSharedIdForm(),
                  ],
                ),
              ),
            );
          }
          return Text('No data');
        });
  }

  Widget showSharedIdForm() {
    print(_diner.sharedId.toString());
    print(User.instance.role);
    if (_diner.sharedId == null && User.instance.role == 'owner') {
      return Column(
        children: <Widget>[
          Text(sharedIdValidResult),
          Container(
            width: 108.0,
            child: TextField(
              controller: _editingController,
              decoration: InputDecoration(hintText: 'sharedID'),
            ),
          ),
          FlatButton(onPressed: onSharedIdBtnPressed, child: Text('Create'))
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_diner.sharedId),
      );
    }
  }

  void onSharedIdBtnPressed() async {
    if (_diner.sharedId == null) {
      String sharedId =
          _editingController.text.replaceAll(new RegExp(r' '), '');
      if (sharedId.length < 6) {
        setState(() {
          sharedIdValidResult = 'ID must contain at least 6 letters';
        });
        return;
      }
      try {
        await _fireService.saveSharedIdOnDb(sharedId, _diner.id);
        _diner.sharedId = sharedId;
        sharedIdValidResult = 'Create sharedID and let people join';
      } catch (e) {
        setState(() {
          sharedIdValidResult = e.toString();
        });
      }
    } else {
      print('Da tao sharedID roi');
    }
  }

  void onFoodsBtnPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FoodPage()));
  }

  void onDrinksBtnPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DrinkPage()));
  }

  void onOrdersBtnPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderPage()));
  }

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
