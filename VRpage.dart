import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:snn/data/blue.dart';


class VRpage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _VRpage();
  }
}

class _VRpage extends State<VRpage>{
  TextEditingController textEditingControllerUrl = new TextEditingController();
  TextEditingController textEditingControllerId = new TextEditingController();




@override
initState(){
  super.initState();
}

void Version1(){
  FlutterYoutube.playYoutubeVideoByUrl(
    apiKey: "<API_KEY>",
    videoUrl: "https://www.youtube.com/watch?v=6mVCNounqSk",
  );
}
  void Version2(){
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://www.youtube.com/watch?v=IxB1wKIrJ04",
    );
  }

void playYoutubeVideoEdit() {
  FlutterYoutube.onVideoEnded.listen((onData) {

  });

  FlutterYoutube.playYoutubeVideoByUrl(
    apiKey: "<API_KEY>",
    videoUrl: textEditingControllerUrl.text,
  );
}





@override
  Widget build(BuildContext context) {
  return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            'MG Health',
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextField(
                  controller: textEditingControllerUrl,
                  decoration:
                  new InputDecoration(labelText: "Enter Youtube URL"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("사용자 설정 YouTube URL"),
                    onPressed: playYoutubeVideoEdit),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Version 1"),
                    onPressed: Version1),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text("Version 2"),
                    onPressed: Version2),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => Bluepage())
              );
            },
            child: Icon(Icons.bluetooth_searching),
        ),
      )
    );
  }
}
