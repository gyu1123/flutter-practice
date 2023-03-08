import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snn/data/EXpage.dart';
import 'package:snn/data/MainPage.dart';
import 'package:snn/data/Misepage.dart';
import 'package:snn/data/VRpage.dart';
import 'package:snn/data/Weather.dart';
import 'package:snn/data/diary.dart';
import 'package:snn/data/theme/xewxex.dart';










class HomeScreen extends StatefulWidget {

  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  int selectIndex = 0;
  int current_index = 0;






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_outlined, size: 20,),
            label: "홈",
            backgroundColor: Colors.blue,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5, size: 20,),
            label: "날씨",
            backgroundColor: Colors.blue,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_outlined, size: 20,),
            label: "미세먼지",
            backgroundColor: Colors.blue,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility, size: 20,),
            label: "운동",
            backgroundColor: Colors.blue,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined, size: 20,),
            label: "VR",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined, size: 20,),
            label: "VDD",
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: current_index,
        onTap: (index){
          setState(() {
            current_index = index;
          });
        },
      ),
      body: Center(
        child: body_item.elementAt(current_index),
      )
    );

  }
  List<Todo> allTodo = [];
  List body_item = [
    MainPage(),
    Weatherpage(),
    MisePage(),
    EXpage(),
    VRpage(),
    YET(),
  ];
}

