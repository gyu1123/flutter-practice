import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snn/data/theme/database_manager.dart';
import 'package:snn/data/theme/text_styles.dart';
import 'package:snn/data/theme/light_color.dart.';
import 'package:snn/data/theme/extention.dart.';
import 'package:snn/data/theme/theme.dart.';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EXpage());

}

class EXpage extends StatefulWidget {
  @override
  _EXpage createState() => _EXpage();

}

DocumentSnapshot snapshot;

class _EXpage extends State<EXpage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  DatabaseReference ref = FirebaseDatabase.instance.reference();


  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("name");






  Future<void> StartButton(){
    final usercol=FirebaseFirestore.instance.collection("jeval").doc("aqur");
    usercol.set({
      "username" : "제발",
      "age" : 5,
    });
  }


  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        'MG Health',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(onPressed: () {
          StartButton();
          print(Row);
         },child: Text(("시작!!"), style: TextStyle(color: Colors.black,fontSize: 20,)),),
      ],
    ).p16;
  }

  Future<void> test(){
    List dataList = [];
    FutureBuilder(
      future: FireStoreDataBase().getData(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text(
            "Something went wrong",
          );
        }
        if (snapshot.connectionState == ConnectionState.done){
          dataList = snapshot.data as List;
          return _items(dataList);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget _items(dataList) => ListView.separated(
      itemCount: dataList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
      dataList[index]["test1000"].toString();
      return dataList[index]["test1000"];
      });



  Widget _category() {
    return Column(
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Category", style: TextStyles.title),
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _categoryCard("Squat",dataList.toString(),
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _categoryCard("OHP", "2",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _categoryCard("Row", "1",
                  color: LightColor.orange, lightColor: LightColor.lightOrange),
              _categoryCard("Curl", "3",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
            ],

          ),

        ),

      ],

    );

  }





 Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP8,
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _header(),
                _category(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}



