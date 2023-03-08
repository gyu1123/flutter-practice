import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';


class Bluepage extends StatefulWidget {
  Bluepage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Bluepage createState() => _Bluepage();
}


class _Bluepage extends State<Bluepage> {

  BleManager _bleManager = BleManager();
  bool _isScanning = false;
  bool _connected = false;
  Peripheral _curPeripheral;           // 연결된 장치 변수
  List<BleDeviceItem> deviceList = []; // BLE 장치 리스트 변수
  String _statusText = '';             // BLE 상태 변수

  @override
  void initState() {
    init();
    super.initState();
  }

  // BLE 초기화 함수
  void init() async {
    //ble 매니저 생성
    await _bleManager.createClient(
        restoreStateIdentifier: "example-restore-state-identifier",
        restoreStateAction: (peripherals) {
          peripherals?.forEach((peripheral) {
            print("Restored peripheral: ${peripheral.name}");
          });
        })
        .catchError((e) => print("Couldn't create BLE client  $e"))
        .then((_) => _checkPermissions())  //매니저 생성되면 권한 확인
        .catchError((e) => print("Permission check error $e"));
  }

  // 권한 확인 함수 권한 없으면 권한 요청 화면 표시, 안드로이드만 상관 있음
  _checkPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.contacts.request().isGranted) {
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location
      ].request();
      print(statuses[Permission.location]);
    }
  }

  //장치 화면에 출력하는 위젯 함수
  list() {
    return ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(deviceList[index].deviceName),
            subtitle: Text(deviceList[index].peripheral.identifier),
            trailing: Text("${deviceList[index].rssi}"),
            onTap: () {  // 리스트중 한개를 탭(터치) 하면 해당 디바이스와 연결을 시도한다.
              connect(index);
            }
        );
      },
    );
  }
  //scan 함수
  void scan() async {
    if(!_isScanning) {
      deviceList.clear(); //기존 장치 리스트 초기화
      //SCAN 시작
      _bleManager.startPeripheralScan().listen((scanResult) {
        //listen 이벤트 형식으로 장치가 발견되면 해당 루틴을 계속 탐.
        //periphernal.name이 없으면 advertisementData.localName확인 이것도 없다면 unknown으로 표시
        var name = scanResult.peripheral.name ?? scanResult.advertisementData.localName ?? "Unknown";
        // 기존에 존재하는 장치면 업데이트
        var findDevice = deviceList.any((element) {
          if(element.peripheral.identifier == scanResult.peripheral.identifier)
          {
            element.peripheral = scanResult.peripheral;
            element.advertisementData = scanResult.advertisementData;
            element.rssi = scanResult.rssi;
            return true;
          }
          return false;
        });
        // 새로 발견된 장치면 추가
        if(!findDevice) {
          deviceList.add(BleDeviceItem(name, scanResult.rssi, scanResult.peripheral, scanResult.advertisementData));
        }
        //페이지 갱신용
        setState((){});
      });
      setState(() { //BLE 상태가 변경되면 화면도 갱신
        _isScanning = true;
        setBLEState('Scanning');
      });
    }
    else {
      //스켄중이었으면 스캔 중지
      _bleManager.stopPeripheralScan();
      setState(() { //BLE 상태가 변경되면 페이지도 갱신
        _isScanning = false;
        setBLEState('Stop Scan');
      });
    }
  }

  //BLE 연결시 예외 처리를 위한 래핑 함수
  _runWithErrorHandling(runFunction) async {
    try {
      await runFunction();
    } on BleError catch (e) {
      print("BleError caught: ${e.errorCode.value} ${e.reason}");
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      print("${e.runtimeType}: $e");
    }
  }

  // 상태 변경하면서 페이지도 갱신하는 함수
  void setBLEState(txt){
    setState(() => _statusText = txt);
  }

  //연결 함수
  connect(index) async {
    if(_connected) {  //이미 연결상태면 연결 해제후 종료
      await _curPeripheral?.disconnectOrCancelConnection();
      return;
    }

    //선택한 장치의 peripheral 값을 가져온다.
    Peripheral peripheral = deviceList[index].peripheral;

    //해당 장치와의 연결상태를 관촬하는 리스너 실행
    peripheral.observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      // 연결상태가 변경되면 해당 루틴을 탐.
      switch(connectionState) {
        case PeripheralConnectionState.connected: {  //연결됨
          _curPeripheral = peripheral;
          setBLEState('connected');
        }
        break;
        case PeripheralConnectionState.connecting: { setBLEState('connecting'); }//연결중
        break;
        case PeripheralConnectionState.disconnected: { //해제됨
          _connected=false;
          print("${peripheral.name} has DISCONNECTED");
          setBLEState('disconnected');
        }
        break;
        case PeripheralConnectionState.disconnecting: { setBLEState('disconnecting');}//해제중
        break;
        default:{//알수없음...
          print("unkown connection state is: \n $connectionState");
        }
        break;
      }
    });

    _runWithErrorHandling(() async {
      //해당 장치와 이미 연결되어 있는지 확인
      bool isConnected = await peripheral.isConnected();
      if(isConnected) {
        print('device is already connected');
        //이미 연결되어 있기때문에 무시하고 종료..
        return;
      }

      //연결 시작!
      await peripheral.connect().then((_) {
        //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다.
        peripheral.discoverAllServicesAndCharacteristics()
            .then((_) => peripheral.services())
            .then((services) async {
          print("PRINTING SERVICES for ${peripheral.name}");
          //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
          for(var service in services) {
            print("Found service ${service.uuid}");
            List<Characteristic> characteristics = await service.characteristics();
            for( var characteristic in characteristics ) {
              print("${characteristic.uuid}");
            }
          }
          //모든 과정이 마무리되면 연결되었다고 표시
          _connected = true;
          print("${peripheral.name} has CONNECTED");
        });
      });
    });
  }

  //페이지 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MG Health"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: list(), //리스트 출력
            ),
            Container(
              child: Row(
                children: <Widget>[
                  RaisedButton( //scan 버튼
                    onPressed: scan,
                    child: Icon(_isScanning?Icons.stop:Icons.bluetooth_searching),
                  ),
                  SizedBox(width: 10,),
                  Text("State : "), Text(_statusText), //상태 정보 표시
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//BLE 장치 정보 저장 클래스
class BleDeviceItem {
  String deviceName;
  Peripheral peripheral;
  int rssi;
  AdvertisementData advertisementData;
  BleDeviceItem(this.deviceName, this.rssi, this.peripheral, this.advertisementData);
}