import 'package:flutter/material.dart';
import 'package:todo_sqlite/services/db.dart';
import 'package:todo_sqlite/myhomepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApplication',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MyHomePage(),
      
    );
  }
}
