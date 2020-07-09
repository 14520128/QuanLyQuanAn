import 'package:flutter/material.dart';
import 'package:myapp/src/repository/firebase_auth.dart';
import 'package:myapp/src/ui/root_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(
        auth: FireAuth.instance,
      ),
    );
  }
}
