import 'package:flutter/material.dart';
import 'package:snn/data/database.dart';
import 'package:snn/data/diary.dart';
import 'package:snn/data/record_screen.dart';
import 'package:snn/data/util.dart';






class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  final dbHelper = DatabaseHelper.instance;
  int selectIndex = 0;

  List<Todo> todos = [
    // Todo(
    //   title: "패스트캠퍼스 강의듣기",
    //   memo: "앱개발 입문강의 듣기",
    //   color: Colors.redAccent.value,
    //   done: 0,
    //   category: "공부",
    //   date: 20210709
    // ),
    // Todo(
    //     title: "패스트캠퍼스 강의듣기2",
    //     memo: "앱개발 입문강의 듣기",
    //     color: Colors.blue.value,
    //     done: 1,
    //     category: "공부",
    //     date: 20210709
    // ),
  ];

  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text(
        'MG Health',
        style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () async {
          // 화면 이동을 해야합니다.
          Todo todo = await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => RecordScreen(todo: Todo(
                  title: "",
                  color: 0,
                  memo: "",
                  done: 0,
                  date: Utils.getFormatTime(DateTime.now().subtract(Duration(days: 1)))
              ))));
          setState((){
            todos.add(todo);
          });
        },
      ),
      body: getMain(),

    );
  }




  Widget getMain(){
    return ListView.builder(
      itemBuilder: (ctx, idx){
        if(idx == 0){
          return Container(
            child: Text("오늘의 목표", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          );
        }else if(idx == 1){

          List<Todo> undone = todos.where((t){
            return t.done == 0;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(undone.length, (_idx){
                Todo t = undone[_idx];
                return InkWell(child: TodoCardWidget(t: t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0){
                        t.done = 1;
                      }else{
                        t.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(t);
                  },
                );
              }),
            ),
          );
        }
        else if(idx == 2){
          return Container(
            child: Text("완료된 목표", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          );
        }else if(idx == 3){

          List<Todo> done = todos.where((t){
            return t.done == 1;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(done.length, (_idx){
                Todo t = done[_idx];
                return InkWell(child: TodoCardWidget(t: t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0){
                        t.done = 1;
                      }else{
                        t.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(t);
                  },
                  onLongPress: () async {
                    Todo todo = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => RecordScreen(todo: t)));
                    setState(() {});
                  },
                );
              }),
            ),
          );
        }
        return Container();
      },
      itemCount: 4,

    );
  }
  List<Todo> allTodo = [];
}

class TodoCardWidget extends StatelessWidget {
  final Todo t;

  TodoCardWidget({Key key, this.t}): super(key: key);

  @override
  Widget build(BuildContext context) {
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDateTime(t.date);

    return Container(
      decoration: BoxDecoration(
          color: Color(t.color),
          borderRadius: BorderRadius.circular(16)
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.title, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
              Text(t.done == 0 ? "미완료" : "완료", style: TextStyle(color: Colors.black),)
            ],
          ),
          Container(height: 8),
          Text(t.memo, style: TextStyle(color: Colors.black)),
          now == t.date ? Container() : Text("${time.month}월 ${time.day}일", style: TextStyle(color: Colors.black))
        ],
      ),
    );
  }
}