import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_sqlite/model/to_do_item.dart';
import 'package:todo_sqlite/services/db.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _task;
  List<TodoItem> _tasks = [];

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24,);

  List<Widget> get _items => _tasks.map((item) => format(item)).toList();

  Widget format(TodoItem item){
    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: FlatButton(
          child: Row(
            children: [
              Icon(item.complete == true? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Colors.white),
              Text(item.task, style: _style),
            ],
          ),
          onPressed: () => _toggle(item),
        ),
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void _toggle(TodoItem item) async {
    item.complete = !item.complete;
    dynamic result = await DB.update(TodoItem.table, item);
    print(result);
    refresh();
  }

  void _delete(TodoItem item) async {
    DB.delete(TodoItem.table, item);
    refresh();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(TodoItem.table);
    _tasks = _results.map((item)=> TodoItem.fromMap(item)).toList();
    setState(() { });
  }

  void _save() async {
    Navigator.of(context).pop();
    TodoItem item = TodoItem(
      task: _task,
      complete: false
    );
  //static Future<int> insert(String table, Model model) async => await _db.insert(table, model.toMap());
    await DB.insert(TodoItem.table, item);
    setState(()=> _task = '');
    refresh();
  }

  void _create(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Create New Task'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'Task Name', hintText: 'eg: Get Grocery'),
            onChanged: (value) => { _task = value },
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: () => _save(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar( title: Text('My Todo Application'),),
      body: Center(
        child: ListView( children: _items)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.library_add),
        tooltip: 'Add New TODO',
        onPressed: () {
          _create(context);
        },
      ),
    );
  }
}
