
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snn/data/database.dart';
import 'diary.dart';


class RecordScreen extends StatefulWidget {

  final Todo todo;

  RecordScreen({Key key, this.todo}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecordScreen();
  }
}


class _RecordScreen extends State<RecordScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  int colorIndex = 0;
  int ctIndex = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text("저장", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              widget.todo.title = nameController.text;
              widget.todo.memo = memoController.text;
              await dbHelper.insertTodo(widget.todo);
              Navigator.of(context).pop(widget.todo);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx){
          if(idx == 0){
            return Container(
              child: Text("제목", style: TextStyle(fontSize: 20),),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            );
          }else if(idx == 1){
            return Container(
              child: TextField(
                controller: nameController,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
            );
          }
          else if(idx == 2){
            return InkWell(child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("색상", style: TextStyle(fontSize: 20),),
                  Container(
                    width: 20,
                    height: 20,
                    color: Color(widget.todo.color),
                  )
                ],
              ),
            ),
              onTap: (){

                List<Color> colors = [
                  Color(0xFF80d3f4),
                  Color(0xFFa794fa),
                  Color(0xFFfb91d1),
                  Color(0xFFfb8a94),
                  Color(0xFFfebd9a),
                  Color(0xFF51e29d),
                  Color(0xFFFFFFFF),
                ];

                widget.todo.color = colors[colorIndex].value;
                colorIndex++;
                setState(() {
                  colorIndex = colorIndex % colors.length;
                });

              },
            );
          }
          else if(idx == 3){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text("목표",  style: TextStyle(fontSize: 20),),
            );
          }else if(idx == 4){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: TextField(
                controller: memoController,
                maxLines: 10,
                minLines: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                ),
              ),
            );
          }

          return Container();
        },
        itemCount: 5,
      ),
    );
  }
}